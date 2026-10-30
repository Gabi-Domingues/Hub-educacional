-- =====================================================================
-- 07 | TAXA DE ABANDONO — REDE MUNICIPAL DO RIO DE JANEIRO
-- Fonte: Indicadores Educacionais do INEP (taxas de rendimento),
-- redistribuídos pela Base dos Dados (br_inep_indicadores_educacionais).
-- A taxa de abandono NÃO consta dos microdados do Censo Escolar: o INEP a
-- calcula a partir da situação do aluno ao final do ano letivo.
-- Cobertura na Base dos Dados: 2006–2024.
--
-- Ordem de execução:
--   7.0  conferência das tabelas e dos códigos (rodar primeiro)
--   7.1  série municipal 2015–2024
--   7.1b regra de qualidade: aprovação + reprovação + abandono = 100%
--   7.2  comparação entre redes (contexto)
--   7.3  tabela Gold para o Power BI (somente anos consistentes)
--   7.4  ranking por escola dentro de cada CRE (nível tático)
--
-- Achado de qualidade (out/2026): na Base dos Dados, os anos de 2023 e
-- 2024 apresentam taxas de abandono de ~28% em todas as redes, e a soma
-- aprovação + reprovação + abandono passa de 100%. Esses anos são
-- excluídos da camada Gold até conferência com o arquivo oficial do INEP.
-- =====================================================================


-- 7.0a Quais tabelas existem no dataset de indicadores
SELECT table_name
FROM `basedosdados.br_inep_indicadores_educacionais.INFORMATION_SCHEMA.TABLES`
ORDER BY table_name;

-- 7.0b Como a tabela municipal escreve "rede" e "localizacao"
SELECT rede, localizacao, COUNT(*) AS linhas
FROM `basedosdados.br_inep_indicadores_educacionais.municipio`
WHERE id_municipio = '3304557' AND ano = 2024
GROUP BY 1, 2
ORDER BY 1, 2;


-- 7.1 Série da taxa de abandono no ensino fundamental (%), rede municipal
SELECT
  ano,
  taxa_abandono_ef                AS abandono_ef,
  taxa_abandono_ef_anos_iniciais  AS abandono_anos_iniciais,
  taxa_abandono_ef_anos_finais    AS abandono_anos_finais,
  taxa_aprovacao_ef               AS aprovacao_ef,
  taxa_reprovacao_ef              AS reprovacao_ef
FROM `basedosdados.br_inep_indicadores_educacionais.municipio`
WHERE id_municipio = '3304557'
  AND LOWER(rede) = 'municipal'
  AND LOWER(localizacao) = 'total'
  AND ano BETWEEN 2015 AND 2024
ORDER BY ano;


-- 7.1b Regra de qualidade de domínio: as três taxas devem somar 100%
-- (tolerância de 0,5 ponto por arredondamento). Anos com status
-- "INCONSISTENTE" não devem ser usados em análises.
SELECT
  ano,
  taxa_aprovacao_ef,
  taxa_reprovacao_ef,
  taxa_abandono_ef,
  ROUND(taxa_aprovacao_ef + taxa_reprovacao_ef + taxa_abandono_ef, 1) AS soma_taxas,
  CASE
    WHEN taxa_abandono_ef IS NULL THEN 'SEM DADO'
    WHEN ABS(taxa_aprovacao_ef + taxa_reprovacao_ef + taxa_abandono_ef - 100) <= 0.5 THEN 'OK'
    ELSE 'INCONSISTENTE'
  END AS status_qualidade
FROM `basedosdados.br_inep_indicadores_educacionais.municipio`
WHERE id_municipio = '3304557'
  AND LOWER(rede) = 'municipal'
  AND LOWER(localizacao) = 'total'
  AND ano BETWEEN 2015 AND 2024
ORDER BY ano;


-- 7.2 Contexto: abandono no ensino fundamental por rede, 2015–2024
SELECT
  ano,
  MAX(IF(LOWER(rede) = 'municipal', taxa_abandono_ef, NULL)) AS rede_municipal,
  MAX(IF(LOWER(rede) = 'estadual',  taxa_abandono_ef, NULL)) AS rede_estadual,
  MAX(IF(LOWER(rede) = 'privada',   taxa_abandono_ef, NULL)) AS rede_privada,
  MAX(IF(LOWER(rede) = 'total',     taxa_abandono_ef, NULL)) AS total_municipio
FROM `basedosdados.br_inep_indicadores_educacionais.municipio`
WHERE id_municipio = '3304557'
  AND LOWER(localizacao) = 'total'
  AND ano BETWEEN 2015 AND 2024
GROUP BY ano
ORDER BY ano;


-- 7.3 Tabela Gold consumida pelo Power BI (série municipal)
CREATE OR REPLACE TABLE `rj-sme-dev.censoescolar_gold.fato_rendimento_municipio` AS
SELECT
  ano,
  'Rede municipal' AS rede,
  taxa_abandono_ef,
  taxa_abandono_ef_anos_iniciais,
  taxa_abandono_ef_anos_finais,
  taxa_aprovacao_ef,
  taxa_reprovacao_ef,
  CURRENT_TIMESTAMP() AS data_carga
FROM `basedosdados.br_inep_indicadores_educacionais.municipio`
WHERE id_municipio = '3304557'
  AND LOWER(rede) = 'municipal'
  AND LOWER(localizacao) = 'total'
  AND ano BETWEEN 2015 AND 2024
  -- somente anos que passam na regra de qualidade (7.1b)
  AND ABS(taxa_aprovacao_ef + taxa_reprovacao_ef + taxa_abandono_ef - 100) <= 0.5;

-- Validação da carga: espera-se 8 linhas (2015–2019 e 2021–2022), sem nulos
SELECT COUNT(*) AS anos, COUNTIF(taxa_abandono_ef IS NULL) AS anos_sem_taxa
FROM `rj-sme-dev.censoescolar_gold.fato_rendimento_municipio`;


-- 7.4 Ranking de abandono por escola dentro de cada CRE (nível tático)
-- Pré-requisito: a tabela "escola" aparecer no resultado de 7.0a.
-- Usa 2022, último ano que passa na regra de qualidade (7.1b), e a CRE
-- do cadastro do Censo 2025. Escolas com taxas inconsistentes são excluídas.
WITH abandono_escola AS (
  SELECT
    CAST(id_escola AS INT64) AS id_escola,
    taxa_abandono_ef
  FROM `basedosdados.br_inep_indicadores_educacionais.escola`
  WHERE id_municipio = '3304557'
    AND ano = 2022
    AND taxa_abandono_ef IS NOT NULL
    AND ABS(taxa_aprovacao_ef + taxa_reprovacao_ef + taxa_abandono_ef - 100) <= 0.5
)
SELECT
  e.id_cre,
  e.nome_escola,
  a.taxa_abandono_ef,
  RANK() OVER (PARTITION BY e.id_cre ORDER BY a.taxa_abandono_ef DESC) AS posicao_na_cre
FROM abandono_escola a
JOIN `rj-sme-dev.censoescolar_silver.escola` e USING (id_escola)
QUALIFY posicao_na_cre <= 10
ORDER BY e.id_cre, posicao_na_cre;


-- 7.5 Conferência da tabela por escola (mesma regra de qualidade):
-- quantas escolas municipais passam ou falham na regra, por ano.
SELECT
  ano,
  COUNTIF(ABS(taxa_aprovacao_ef + taxa_reprovacao_ef + taxa_abandono_ef - 100) <= 0.5) AS escolas_ok,
  COUNTIF(ABS(taxa_aprovacao_ef + taxa_reprovacao_ef + taxa_abandono_ef - 100) > 0.5)  AS escolas_inconsistentes
FROM `basedosdados.br_inep_indicadores_educacionais.escola`
WHERE id_municipio = '3304557'
  AND LOWER(rede) = 'municipal'
  AND ano BETWEEN 2019 AND 2024
GROUP BY ano
ORDER BY ano;
