# Resolução

## Implementação SQL

### 1. Criação do Banco de Dados

```sql

### 1. Criação do Banco de Dados

-- Criação do banco de dados
CREATE DATABASE sistema_eventos;

-- Seleciona o banco de dados
USE sistema_eventos;

```

### 2. Criação das Tabelas

```sql
-- =========================
-- TABELA: palestrantes
-- =========================
CREATE TABLE palestrantes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL
);

-- =========================
-- TABELA: eventos
-- =========================
CREATE TABLE eventos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    data_evento DATE NOT NULL,
    local VARCHAR(200) NOT NULL,
    capacidade INT NOT NULL,
    palestrante_id INT NOT NULL,
);

-- =========================
-- TABELA: inscricoes
-- =========================
CREATE TABLE inscricoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evento_id INT NOT NULL,
    nome_participante VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    data_inscricao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    presente TINYINT DEFAULT 0,
);

```

### 3. Inserção de Dados Iniciais

```sql
-- =========================
-- INSERIR PALESTRANTES
-- =========================
INSERT INTO palestrantes (nome, especialidade, email)
VALUES
('Maria Silva', 'Inteligência Artificial', 'maria@exemplo.com'),
('João Santos', 'Marketing Digital', 'joao@exemplo.com');

-- =========================
-- INSERIR EVENTOS
-- =========================
INSERT INTO eventos
(titulo, data_evento, local, capacidade, palestrante_id)
VALUES
('Workshop de IA', '2023-11-15', 'Auditório Principal', 100, 1),
('Conferência de Marketing', '2023-12-10', 'Sala de Convenções', 200, 2);

-- =========================
-- INSERIR INSCRIÇÕES
-- =========================
INSERT INTO inscricoes
(evento_id, nome_participante, email, data_inscricao, presente)
VALUES
(1, 'Carlos Oliveira', 'carlos@email.com', '2023-11-01 09:00:00', 1),
(1, 'Ana Souza', 'ana@email.com', '2023-11-02 10:30:00', 1),
(2, 'Bruno Lima', 'bruno@email.com', '2023-12-01 14:15:00', 0);
```

### 4. View para Consulta

```sql

-- View para listar eventos com detalhes
CREATE VIEW vw_eventos_detalhados AS
SELECT 
    e.id,
    e.titulo,
    e.data_evento,
    e.local,
    e.capacidade,
    p.nome AS palestrante,
    p.especialidade,
    -- Total de inscritos no evento
    -- COUNT ignora valores NULL
    -- Se não houver inscrições → retorna 0
    COUNT(i.id) AS total_inscritos,
    -- Cálculo de vagas disponíveis
    -- capacidade total - quantidade de inscritos
    e.capacidade - COUNT(i.id) AS vagas_disponiveis
FROM 
    eventos e
-- =========================================
-- LEFT JOIN com palestrantes
-- =========================================
-- ✔ Traz TODOS os eventos
-- ✔ Se não houver palestrante → retorna NULL
-- ❗ Se fosse INNER JOIN, eventos sem palestrante sumiriam
LEFT JOIN 
    palestrantes p ON e.palestrante_id = p.id
-- =========================================
-- LEFT JOIN com inscrições
-- =========================================
-- ✔ Traz TODOS os eventos
-- ✔ Se não houver inscrições → i.id será NULL
-- ✔ Permite usar COUNT corretamente (retorna 0)
-- ❗ Se fosse INNER JOIN, eventos sem inscritos sumiriam
LEFT JOIN 
    inscricoes i ON e.id = i.evento_id
-- =========================================
-- GROUP BY (obrigatório com COUNT)
-- =========================================
-- Agrupa os dados por evento
-- Evita duplicação causada pelo JOIN com inscrições
GROUP BY 
    e.id, e.titulo, e.data_evento, e.local, e.capacidade, p.nome, p.especialidade;
    

-- Consultar a view
SELECT * FROM vw_eventos_detalhados;
```

### 5. Consultas Úteis

```sql
-- 1. Listar todos os eventos com suas respectivas informações

SELECT * FROM `eventos`


-- 2. Mostrar apenas eventos com vagas disponíveis (usando a view criada)

SELECT id, titulo, data_evento, local, vagas_disponiveis 
FROM vw_eventos_detalhados
WHERE vagas_disponiveis > 0;


-- 3. Listar participantes inscritos em um evento específico

SELECT 
    eventos.titulo AS evento,
    inscricoes.nome_participante,
    inscricoes.email,
    inscricoes.data_inscricao,
    inscricoes.presente
FROM inscricoes
INNER JOIN eventos
ON inscricoes.evento_id = eventos.id
WHERE eventos.id = 1;


```
