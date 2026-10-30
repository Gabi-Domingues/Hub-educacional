-- =====================================================================
-- 06 | SÉRIE HISTÓRICA DA REDE MUNICIPAL (Figura 3.3)
-- Fonte: Base dos Dados — br_inep_censo_escolar (microdados do INEP)
--   * escola:    2007–2025 (1 linha = 1 escola)  -> número de unidades
--   * matricula: 2007–2020 (1 linha = 1 matrícula) -> total de matrículas
--   * 2025: tabela do piloto (censoescolar.matricula_2025)
-- Recorte: Rio de Janeiro (id_municipio = '3304557'), rede municipal.
-- Os filtros por sigla_uf e ano usam o particionamento das tabelas e
-- reduzem o volume processado (custo) no BigQuery.
-- =====================================================================

-- 6.0 Conferência dos códigos usados nos filtros (rodar antes)
SELECT rede, tipo_situacao_funcionamento, COUNT(*) AS escolas
FROM `basedosdados.br_inep_censo_escolar.escola`
WHERE ano = 2025 AND sigla_uf = 'RJ' AND id_municipio = '3304557'
GROUP BY 1, 2
ORDER BY 1, 2;

SELECT tipo_atendimento_turma, COUNT(*) AS matriculas
FROM `basedosdados.br_inep_censo_escolar.matricula`
WHERE ano = 2020 AND sigla_uf = 'RJ' AND id_municipio = '3304557'
  AND LOWER(rede) IN ('municipal', '3')
GROUP BY 1
ORDER BY 1;

-- 6.1 Unidades escolares da rede municipal, 2007–2025
SELECT
  ano,
  COUNT(*) AS escolas_no_cadastro,
  COUNTIF(tipo_situacao_funcionamento IN ('1', 'Em atividade')) AS escolas_em_atividade
FROM `basedosdados.br_inep_censo_escolar.escola`
WHERE sigla_uf = 'RJ'
  AND id_municipio = '3304557'
  AND LOWER(rede) IN ('municipal', '3')
GROUP BY ano
ORDER BY ano;

-- 6.2 Matrículas da rede municipal, 2007–2020 (microdados por matrícula)
-- O detalhamento por tipo de atendimento permite separar matrículas de
-- escolarização das de AEE e atividade complementar, que não entram no
-- total de matrículas da educação básica divulgado pelo INEP.
SELECT
  ano,
  tipo_atendimento_turma,
  COUNT(*) AS matriculas
FROM `basedosdados.br_inep_censo_escolar.matricula`
WHERE sigla_uf = 'RJ'
  AND id_municipio = '3304557'
  AND LOWER(rede) IN ('municipal', '3')
  AND ano BETWEEN 2007 AND 2020
GROUP BY ano, tipo_atendimento_turma
ORDER BY ano, tipo_atendimento_turma;

-- 6.3 Matrículas da rede municipal em 2025 (dados do piloto)
SELECT 2025 AS ano, SUM(QT_MAT_BAS) AS matriculas
FROM `rj-sme-dev.censoescolar.matricula_2025`
WHERE CO_MUNICIPIO = 3304557 AND TP_DEPENDENCIA = 3;

-- Observação: de 2021 a 2024 o INEP não publica microdados por matrícula
-- (LGPD). Para esses anos, use os microdados agregados por escola
-- (coluna QT_MAT_BAS) de cada edição ou a Sinopse Estatística do INEP.
