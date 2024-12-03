-- QUESTÃO 01
SELECT to_tsvector('english', 'unity is bad');
-- Resp01:
-- 'bad':3 'uniti':1

-- QUESTÃO 02
SELECT title FROM best_films WHERE to_tsvector('english', description) @@ to_tsquery('english', 'family & drama');
-- Resp01:
-- "Belfast", "CODA". Porém, apenas "CODA" possuí esse fragmento na descrição.

-- QUESTÃO 03
SELECT title FROM best_films WHERE to_tsvector('english', description) @@ to_tsquery('english', 'family <-> drama');
-- Resp01:
-- "CODA".

-- QUESTÃO 04
-- Resp01:
-- As stop-words são removidas do vetor de texto.

-- QUESTÃO 05
SELECT title FROM best_films WHERE to_tsvector('english', description) @@ to_tsquery('english', 'fame <-> about <-> fortunes');
-- Being the Ricardos foi o filme retornado. Encontra o fragmento "fame and fortunes", que é similiar, mas não exatamente igual.

-- QUESTÃO 06
-- 6.1
SELECT title FROM best_films WHERE to_tsvector('english', description) @@ to_tsquery('english', 'fame <3> about <3> fortunes');

-- 6.2
SELECT title FROM best_films WHERE to_tsvector('english', description) @@ to_tsquery('english', 'tropical <1> alien <1> planet');
-- Resp01:
-- Don't Look Up

-- QUESTÃO 07
SELECT title FROM best_films WHERE to_tsvector('english', description) @@ phraseto_tsquery('english', 'tropical alien planet');
-- Resp01:
-- Don't Look Up. A função phraseto_tsquery() busca por uma sequência exata de palavras.

-- QUESTÃO 08
-- 8.1
ALTER TABLE best_films ADD COLUMN description_ts tsvector GENERATED ALWAYS AS (to_tsvector('english', description)) STORED;
-- 8.2
CREATE INDEX description_ts_idx ON best_films USING gin(description_ts);
-- 8.3
SELECT title FROM best_films WHERE description_ts @@ to_tsquery('english', 'drama');
-- Resp01:
-- "Belfast", "CODA", "Being the Ricardos" e "Drive My Car" possuem a palavra "drama" na descrição.

-- QUESTÃO 09
SELECT title, ts_rank(description_ts, to_tsquery('english', 'family & drama')) AS rank_value FROM best_films WHERE description_ts @@ to_tsquery('english', 'family & drama') ORDER BY rank_value DESC;
-- Resp01:
-- "CODA" possui um rank_value de 0.09910413, indicando uma correspondência mais forte com a consulta 'family & drama'.
-- "Belfast" possui um rank_value de 1e-16, indicando uma correspondência muito fraca.
