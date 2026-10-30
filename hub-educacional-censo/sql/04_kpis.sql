-- =====================================================================
-- 04 | INDICADORES DO DASHBOARD ESTRATÉGICO (piloto)
-- Cada consulta reproduz um número apresentado na monografia.
-- =====================================================================

-- 4.1 Visão geral (Figura 3.1): total de matrículas e por sexo
SELECT
  SUM(qt_mat_basica)    AS total_matriculas,      -- texto: 585.905
  SUM(qt_mat_feminino)  AS matriculas_feminino,   -- texto: 284.998
  SUM(qt_mat_masculino) AS matriculas_masculino   -- texto: 300.907
FROM `rj-sme-dev.censoescolar_gold.fato_escola`;

-- 4.2 Matrículas por etapa (Figura 3.1)
SELECT d.etapa, SUM(f.qt_matriculas) AS matriculas
FROM `rj-sme-dev.censoescolar_gold.fato_matricula` f
JOIN `rj-sme-dev.censoescolar_gold.dim_etapa` d USING (id_etapa)
GROUP BY d.etapa
ORDER BY matriculas DESC;

-- 4.3 Matrículas por CRE (Figura 3.1)
SELECT de.id_cre, SUM(f.qt_mat_basica) AS matriculas
FROM `rj-sme-dev.censoescolar_gold.fato_escola` f
JOIN `rj-sme-dev.censoescolar_gold.dim_escola` de USING (id_escola)
GROUP BY de.id_cre
ORDER BY de.id_cre;

-- 4.4 Unidades escolares (Figura 3.3): total x em atividade
SELECT
  COUNT(*)                 AS escolas_no_cadastro,
  COUNTIF(em_atividade)    AS escolas_em_atividade,
  COUNTIF(f.qt_mat_basica > 0) AS escolas_com_matricula
FROM `rj-sme-dev.censoescolar_gold.dim_escola` de
LEFT JOIN `rj-sme-dev.censoescolar_gold.fato_escola` f USING (id_escola);

-- 4.5 Média de alunos por turma (Tabela A.3)
SELECT ROUND(SAFE_DIVIDE(SUM(qt_mat_basica), SUM(qt_tur_basica)), 1) AS media_alunos_turma  -- texto: 27,2
FROM `rj-sme-dev.censoescolar_gold.fato_escola`;

-- 4.6 % de matrículas EJA por CRE (Tabela A.11)
SELECT de.id_cre,
  ROUND(100 * SAFE_DIVIDE(SUM(f.qt_mat_eja), SUM(f.qt_mat_basica)), 2) AS pct_matriculas_eja
FROM `rj-sme-dev.censoescolar_gold.fato_escola` f
JOIN `rj-sme-dev.censoescolar_gold.dim_escola` de USING (id_escola)
GROUP BY de.id_cre
ORDER BY de.id_cre;

-- 4.7 Educação especial (Figura 3.2)
SELECT
  COUNTIF(tp_aee IN (1, 2))  AS escolas_que_ofertam_aee,     -- texto: 531 (conferir códigos de TP_AEE no dicionário do INEP)
  COUNTIF(in_sala_recursos = 1) AS escolas_com_sala_recursos, -- texto: 761
  SUM(qt_mat_educacao_especial) AS matriculas_educacao_especial -- texto: ~32 mil
FROM `rj-sme-dev.censoescolar_gold.fato_escola`;
