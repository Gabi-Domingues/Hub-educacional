-- =====================================================================
-- 01 | CAMADA BRONZE — validação da carga
-- Tabelas carregadas sem transformação a partir dos microdados públicos
-- do Censo Escolar 2025 (INEP), recorte: município do Rio de Janeiro.
-- Granularidade: 1 linha = 1 escola (dados agregados por escola).
-- =====================================================================

-- 1.1 Volume de registros por tabela
SELECT 'escola_2025'    AS tabela, COUNT(*) AS linhas, COUNT(DISTINCT CO_ENTIDADE) AS escolas_distintas FROM `rj-sme-dev.censoescolar.escola_2025`
UNION ALL SELECT 'matricula_2025', COUNT(*), COUNT(DISTINCT CO_ENTIDADE) FROM `rj-sme-dev.censoescolar.matricula_2025`
UNION ALL SELECT 'turmas_2025',    COUNT(*), COUNT(DISTINCT CO_ENTIDADE) FROM `rj-sme-dev.censoescolar.turmas_2025`
UNION ALL SELECT 'docente_2025',   COUNT(*), COUNT(DISTINCT CO_ENTIDADE) FROM `rj-sme-dev.censoescolar.docente_2025`
UNION ALL SELECT 'gestor_2025',    COUNT(*), COUNT(DISTINCT CO_ENTIDADE) FROM `rj-sme-dev.censoescolar.gestor_2025`;

-- 1.2 Recorte territorial: todas as linhas devem ser do município 3304557 (Rio de Janeiro) e do ano 2025
SELECT CO_MUNICIPIO, NU_ANO_CENSO, COUNT(*) AS linhas
FROM `rj-sme-dev.censoescolar.escola_2025`
GROUP BY 1, 2;

-- 1.3 Composição por dependência administrativa e situação de funcionamento
-- TP_DEPENDENCIA: 1 Federal | 2 Estadual | 3 Municipal | 4 Privada
-- TP_SITUACAO_FUNCIONAMENTO: 1 Em atividade | 2 Paralisada | 3 Extinta | 4 Extinta em anos anteriores
SELECT TP_DEPENDENCIA, TP_SITUACAO_FUNCIONAMENTO, COUNT(*) AS escolas
FROM `rj-sme-dev.censoescolar.escola_2025`
GROUP BY 1, 2
ORDER BY 1, 2;

-- 1.4 Duplicidade da chave (esperado: 0 linhas em cada tabela)
SELECT 'escola_2025' AS tabela, CO_ENTIDADE, COUNT(*) AS n FROM `rj-sme-dev.censoescolar.escola_2025` GROUP BY 1, 2 HAVING n > 1
UNION ALL SELECT 'matricula_2025', CO_ENTIDADE, COUNT(*) FROM `rj-sme-dev.censoescolar.matricula_2025` GROUP BY 1, 2 HAVING COUNT(*) > 1
UNION ALL SELECT 'turmas_2025',    CO_ENTIDADE, COUNT(*) FROM `rj-sme-dev.censoescolar.turmas_2025`    GROUP BY 1, 2 HAVING COUNT(*) > 1;

-- 1.5 Integridade: escolas presentes nas tabelas temáticas e ausentes no cadastro (esperado: 0)
SELECT 'matricula' AS origem, COUNT(*) AS escolas_sem_cadastro
FROM `rj-sme-dev.censoescolar.matricula_2025` m
LEFT JOIN `rj-sme-dev.censoescolar.escola_2025` e USING (CO_ENTIDADE)
WHERE e.CO_ENTIDADE IS NULL
UNION ALL
SELECT 'turmas', COUNT(*)
FROM `rj-sme-dev.censoescolar.turmas_2025` t
LEFT JOIN `rj-sme-dev.censoescolar.escola_2025` e USING (CO_ENTIDADE)
WHERE e.CO_ENTIDADE IS NULL;

-- 1.6 Completude dos campos críticos (nulos)
SELECT
  COUNTIF(CO_ENTIDADE IS NULL)        AS nulos_co_entidade,
  COUNTIF(TP_DEPENDENCIA IS NULL)     AS nulos_dependencia,
  COUNTIF(CO_ORGAO_REGIONAL IS NULL)  AS nulos_orgao_regional,
  COUNTIF(TP_SITUACAO_FUNCIONAMENTO IS NULL) AS nulos_situacao
FROM `rj-sme-dev.censoescolar.escola_2025`;
