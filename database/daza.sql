-- Active: 1741960790739@@127.0.0.1@3308@world
-- Criação do banco de dados
CREATE DATABASE daza_fc;
USE daza_fc;

CREATE TABLE IF NOT EXISTS jogadores (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) CHARACTER SET utf8mb4,
  email VARCHAR(100) CHARACTER SET utf8mb4,
  telefone VARCHAR(20) CHARACTER SET utf8mb4,
  posicao VARCHAR(50) CHARACTER SET utf8mb4,
  numero_camisa INT
);

CREATE TABLE IF NOT EXISTS usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(100) CHARACTER SET utf8mb4,
  senha VARCHAR(200) CHARACTER SET utf8mb4,
  role ENUM('jogador', 'diretoria') CHARACTER SET utf8mb4 DEFAULT 'jogador'
);


