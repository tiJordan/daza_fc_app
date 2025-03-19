from sqlite3 import connect
from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector
import os
from dotenv import load_dotenv
import re
from werkzeug.security import generate_password_hash, check_password_hash
import jwt
import datetime

# Carrega as vari�veis do .env
load_dotenv()

app = Flask(__name__)
CORS(app)

app.config['JWT_SECRET'] = os.getenv("JWT_SECRET", "defaultsecret")
app.config['JWT_ALGORITHM'] = "HS256"

# Conex�o com MySQL com charset utf8mb4 para acentua��o
try:
    db = mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME"),
        port=int(os.getenv("DB_PORT", 3306)),
        charset='utf8mb4'
    )
    cursor = db.cursor(dictionary=True)
    print("Conectado ao MySQL!")
except mysql.connector.Error as err:
    print("Erro ao conectar:", err)
    exit(1)

# Valida email se fornecido (opcional)
def is_valid_email(email):
    if not email:
        return True
    regex = r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    return re.fullmatch(regex, email)

# Lista de posi��es permitidas
ALLOWED_POSITIONS = ['Goleiro', 'Zagueiro', 'Lateral', 'Volante', 'Meia', 'Atacante']

@app.route('/api/register', methods=['POST'])
def register():
    try:
        data = request.get_json()
        name = data.get("nome")
        email = data.get("email", "")  # opcional
        telefone = data.get("telefone", "")  # opcional
        posicoes = data.get("posicoes")  # deve ser uma lista (1 ou 2 posições)
        numero_camisa = data.get("numero_camisa")
        senha = data.get("senha")
        role = data.get("role", "jogador")  # Padrão é 'jogador' caso não seja fornecido
        
        # Verifica campos obrigatórios
        if not name or not senha or not posicoes or not numero_camisa:
            return jsonify({"error": "Campos obrigatórios: nome, posicoes, número da camisa e senha"}), 400
        
        # Criptografa a senha
        hashed_password = generate_password_hash(senha)
        
        # Converte a lista de posições para uma string separada por vírgula
        posicoes_str = ", ".join(posicoes)
        
        # Insere na tabela jogadores
        sql_jogador = """
            INSERT INTO jogadores (nome, email, telefone, posicao, numero_camisa) 
            VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(sql_jogador, (name, email, telefone, posicoes_str, numero_camisa))
        db.commit()
        
        # Insere na tabela usuários com a role correta
        sql_usuario = """
            INSERT INTO usuarios (nome, senha, role) 
            VALUES (%s, %s, %s)
        """
        cursor.execute(sql_usuario, (name, hashed_password, role))
        db.commit()

        return jsonify({"message": "Cadastro realizado com sucesso!"}), 200
    except Exception as e:
        db.rollback()
        return jsonify({"error": str(e)}), 500

@app.route('/api/login', methods=['POST'])
def login():
    try:
        data = request.get_json()
        name = data.get("nome")
        senha = data.get("senha")
        
        if not name or not senha:
            return jsonify({"error": "Nome e senha são obrigatários"}), 400
        
        sql = "SELECT * FROM usuarios WHERE nome = %s"
        cursor.execute(sql, (name,))
        user = cursor.fetchone()
        if not user:
            return jsonify({"error": "Usuário não cadastrado"}), 401
        
        if not check_password_hash(user['senha'], senha):
            return jsonify({"error": "Senha incorreta"}), 401
        
        payload = {
            "id": user["id"],
            "role": user["role"],
            "exp": datetime.datetime.utcnow() + datetime.timedelta(days=1)
        }
        token = jwt.encode(payload, app.config['JWT_SECRET'], algorithm=app.config['JWT_ALGORITHM'])
        
        # Fecha o cursor e a conexão
        #cursor.close()
        #connect.close()
        
        return jsonify({"message": "Login realizado com sucesso!", "token": token, "role": user["role"]}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
 
    
@app.route('/api/test', methods=['GET'])
def test():
    return jsonify({"message": "Servidor funcionando!"}), 200

@app.route('/api/players', methods=['GET'])
def get_players():
    try:
        sql = """
            SELECT jogadores.nome, jogadores.numero_camisa, jogadores.posicao AS posicoes,
                   COALESCE(SUM(estatisticas.gols), 0) AS gols,
                   COALESCE(SUM(estatisticas.assistencias), 0) AS assistencias,
                   COALESCE(SUM(estatisticas.cartoes_amarelos), 0) AS cartoes_amarelos,
                   COALESCE(SUM(estatisticas.cartoes_vermelhos), 0) AS cartoes_vermelhos
            FROM jogadores
            LEFT JOIN estatisticas ON jogadores.nome = estatisticas.nome_jogador
            GROUP BY jogadores.nome, jogadores.numero_camisa, jogadores.posicao
        """
        cursor.execute(sql)
        players = cursor.fetchall()
        return jsonify(players), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/api/statistics', methods=['POST'])
def add_statistics():
    try:
        data = request.get_json()
        player_name = data.get('player')
        goals = data.get('goals', 0)
        assists = data.get('assists', 0)
        yellow_cards = data.get('yellowCards', 0)
        red_cards = data.get('redCards', 0)

        if not player_name:
            return jsonify({"error": "Nome do jogador é obrigatório"}), 400

        # Insere as estatísticas no banco de dados
        sql = """
            INSERT INTO estatisticas (nome_jogador, gols, assistencias, cartoes_amarelos, cartoes_vermelhos)
            VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(sql, (player_name, goals, assists, yellow_cards, red_cards))
        db.commit()

        return jsonify({"message": "Estatísticas adicionadas com sucesso!"}), 200
    except Exception as e:
        db.rollback()
        return jsonify({"error": str(e)}), 500    


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)
