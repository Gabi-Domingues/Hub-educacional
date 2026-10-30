-- =====================================================================
-- 03 | CAMADA GOLD — modelo dimensional (fact constellation)
-- Dimensões: dim_escola, dim_cre, dim_etapa
-- Fatos: fato_matricula (escola x etapa), fato_turma (escola x etapa),
--        fato_docente (escola), fato_escola (escola: infraestrutura)
-- =====================================================================

CREATE SCHEMA IF NOT EXISTS `rj-sme-dev.censoescolar_gold`;

CREATE OR REPLACE TABLE `rj-sme-dev.censoescolar_gold.dim_escola` AS
SELECT id_escola, nome_escola, id_cre, tp_localizacao, tp_situacao_funcionamento, em_atividade
FROM `rj-sme-dev.censoescolar_silver.escola`;

CREATE OR REPLACE TABLE `rj-sme-dev.censoescolar_gold.dim_cre` AS
SELECT DISTINCT id_cre
FROM `rj-sme-dev.censoescolar_silver.escola`;

CREATE OR REPLACE TABLE `rj-sme-dev.censoescolar_gold.dim_etapa` AS
SELECT * FROM UNNEST([
  STRUCT(1 AS id_etapa, 'Creche' AS etapa),
  STRUCT(2, 'Pré-escola'),
  STRUCT(3, 'Anos Iniciais'),
  STRUCT(4, 'Anos Finais'),
  STRUCT(5, 'EJA Fundamental')
]);

-- Fato matrícula: uma linha por escola e etapa
CREATE OR REPLACE TABLE `rj-sme-dev.censoescolar_gold.fato_matricula` AS
SELECT m.ano, m.id_escola, e.id_etapa, e.qt_matriculas
FROM `rj-sme-dev.censoescolar_silver.matricula` m,
UNNEST([
  STRUCT(1 AS id_etapa, m.qt_mat_creche AS qt_matriculas),
  STRUCT(2, m.qt_mat_pre_escola),
  STRUCT(3, m.qt_mat_anos_iniciais),
  STRUCT(4, m.qt_mat_anos_finais),
  STRUCT(5, m.qt_mat_eja_fundamental)
]) e;

CREATE OR REPLACE TABLE `rj-sme-dev.censoescolar_gold.fato_turma` AS
SELECT t.ano, t.id_escola, e.id_etapa, e.qt_turmas
FROM `rj-sme-dev.censoescolar_silver.turma` t,
UNNEST([
  STRUCT(1 AS id_etapa, t.qt_tur_creche AS qt_turmas),
  STRUCT(2, t.qt_tur_pre_escola),
  STRUCT(3, t.qt_tur_anos_iniciais),
  STRUCT(4, t.qt_tur_anos_finais),
  STRUCT(5, t.qt_tur_eja_fundamental)
]) e;

CREATE OR REPLACE TABLE `rj-sme-dev.censoescolar_gold.fato_docente` AS
SELECT ano, id_escola, qt_docentes, qt_docentes_superior
FROM `rj-sme-dev.censoescolar_silver.docente`;

CREATE OR REPLACE TABLE `rj-sme-dev.censoescolar_gold.fato_escola` AS
SELECT
  e.ano, e.id_escola,
  e.tp_aee, e.in_sala_recursos, e.in_biblioteca, e.in_lab_informatica, e.in_lab_ciencias,
  e.in_rampas, e.in_banheiro_pne, e.in_internet,
  m.qt_mat_basica, m.qt_mat_feminino, m.qt_mat_masculino, m.qt_mat_educacao_especial, m.qt_mat_eja,
  t.qt_tur_basica
FROM `rj-sme-dev.censoescolar_silver.escola` e
LEFT JOIN `rj-sme-dev.censoescolar_silver.matricula` m USING (ano, id_escola)
LEFT JOIN `rj-sme-dev.censoescolar_silver.turma` t USING (ano, id_escola);
