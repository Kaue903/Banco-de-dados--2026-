# Sistema de Gerenciamento de Eventos

## Contexto

Você foi contratado para desenvolver um sistema de banco de dados para uma empresa que organiza eventos corporativos e acadêmicos. O sistema deve permitir o gerenciamento de eventos, palestrantes e inscrições de participantes.

## Requisitos

Desenvolva um banco de dados em MySQL que atenda às seguintes necessidades:

1. Cadastro de Palestrantes  
Armazene informações dos palestrantes, incluindo:  

- `id`: Identificador único  
- `nome`: Nome completo  
- `especialidade`: Área de atuação  
- `email`: Contato (deve ser único) 

2. Cadastro de Eventos  
Registre os eventos com os seguintes dados:  

- `id`: Identificador único  
- `titulo`: Nome do evento  
- `data_evento`: Data da realização  
- `local`: Local onde ocorrerá o evento  
- `capacidade`: Número máximo de participantes (padrão: 50)  
- `palestrante_id`: Palestrante responsável pelo evento  

3. Registro de Inscrições  
Controle as inscrições dos participantes: 

- `id`: Identificador único  
- `evento_id`: Evento no qual o participante está inscrito  
- `nome_participante`: Nome do participante  
- `email`: Contato do participante  
- `data_inscricao`: Data e hora da inscrição (definida automaticamente)  
- `presente`: Indica se o participante compareceu ao evento (padrão: `FALSE`)

4. Controle de presença dos participantes
5. Controle de capacidade dos eventos (não permitir mais inscrições do que a capacidade)

## Tarefas

### 1. Modelagem de Dados

Crie as seguintes tabelas com seus respectivos campos:

- **Palestrantes**: Armazene informações sobre os especialistas que ministrarão os eventos
- **Eventos**: Registre os dados dos eventos, incluindo qual palestrante está responsável
- **Inscrições**: Controle quem está inscrito em cada evento

### 2. Implementação SQL

Desenvolva os scripts SQL para:

- Criar o banco de dados com codificação UTF-8
- Criar as tabelas com campos apropriados e relacionamentos
- Inserir os seguintes palestrantes:
  * Maria Silva, especialista em Inteligência Artificial, email: maria@exemplo.com
  * João Santos, especialista em Marketing Digital, email: joao@exemplo.com
- Inserir os seguintes eventos:
  * Workshop de IA, data: 15/11/2023, local: Auditório Principal, capacidade: 100 pessoas, palestrante: Maria Silva
  * Conferência de Marketing, data: 10/12/2023, local: Sala de Convenções, capacidade: 200 pessoas, palestrante: João Santos
- Inserir as seguintes inscrições:
  * Carlos Oliveira (carlos@email.com) no Workshop de IA
  * Ana Souza (ana@email.com) no Workshop de IA
  * Bruno Lima (bruno@email.com) na Conferência de Marketing
- Criar uma view que mostre informações detalhadas dos eventos, incluindo vagas disponíveis

```sql
-- View para listar eventos com detalhes (modelo para implementação)
CREATE VIEW vw_eventos_detalhados AS
SELECT 
    e.id,
    e.titulo,
    e.data_evento,
    e.local,
    e.capacidade,
    p.nome AS palestrante,
    p.especialidade,
    COUNT(i.id) AS total_inscritos,
    e.capacidade - COUNT(i.id) AS vagas_disponiveis
FROM 
    eventos e
LEFT JOIN 
    palestrantes p ON e.palestrante_id = p.id
LEFT JOIN 
    inscricoes i ON e.id = i.evento_id
GROUP BY 
    e.id, e.titulo, e.data_evento, e.local, e.capacidade, p.nome, p.especialidade;


-- Consultar a view
SELECT * FROM vw_eventos_detalhados;
```

### 3. Consultas

Escreva consultas SQL para:

<!-- Consulta_1 -->
- Listar todos os eventos com suas respectivas informações

SELECT * FROM eventos

![alt text](Prints/image-1.png)

--------------------------------------------

<!-- Consulta_2 -->


- Mostrar apenas eventos com vagas disponíveis (usando a view criada)

```sql
-- Exemplo de consulta usando a view para listar eventos com vagas disponíveis
SELECT id, titulo, data_evento, local, vagas_disponiveis 
FROM vw_eventos_detalhados
WHERE vagas_disponiveis > 0;



```

![alt text](Prints/image.png)

-----------------------------------------------------


<!-- Consulta_3 -->
- Listar participantes inscritos em um evento específico

```sql

SELECT 
    eventos.titulo AS evento,
    inscricoes.nome_participante,
    inscricoes.email,
    inscricoes.data_inscricao,
    inscricoes.presente
FROM inscricoes
INNER JOIN eventos
ON inscricoes.evento_id = eventos.id
WHERE eventos.titulo = 'Workshop de IA';

```

![alt text](Prints/image-3.png)

-----------------------------------------------------


## Entrega

A principal entrega deve ser prints das consultas e cadastros realizados, juntamente com:

1. Um arquivo SQL contendo todos os comandos necessários para:
   - Criar o banco de dados e as tabelas
   - Inserir os dados iniciais
   - Criar a view solicitada
   - Demonstrar as consultas requisitadas

2. Screenshots "Prints" que mostrem:
   - A execução bem-sucedida da criação das tabelas e os dados inseridos nas tabelas (usando SELECT)
   Exemplo: tb_eventos.png, tb_inscricoes.png, etc...

   - O resultado da view criada
   
   - Os resultados das consultas solicitadas
   Exemplo: Consulta_1.png, Consulta_2.png, etc...

## Dicas

- Use chaves estrangeiras para manter a integridade referencial
- Utilize AUTO_INCREMENT para os campos de ID
- Defina valores DEFAULT para campos como capacidade e presente
- Implemente UNIQUE para o email dos palestrantes
- Utilize GROUP BY nas consultas que calculam estatísticas como total de inscritos
- Aproveite a view criada para simplificar suas consultas

---

