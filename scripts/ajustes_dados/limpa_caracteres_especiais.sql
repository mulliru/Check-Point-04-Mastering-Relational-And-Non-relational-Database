CREATE OR REPLACE FUNCTION LIMPA_CARACTERES_ESPECIAIS(
    p_texto IN VARCHAR2
) RETURN VARCHAR2
IS
    v_texto_limpo VARCHAR2(4000);
    v_texto_sem_acentos VARCHAR2(4000);
BEGIN
    v_texto_limpo := REGEXP_REPLACE(p_texto, '[^a-zA-Z0-9áàâãäéèêëíìîïóòôõöúùûüçÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇñÑ ]', ' ');
    v_texto_sem_acentos := TRANSLATE(
        v_texto_limpo,
        'áàâãäéèêëíìîïóòôõöúùûüçÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇñÑ',
        'aaaaaeeeeiiiiooooouuuucAAAAAEEEEIIIIOOOOOUUUUCCnN'
    );
    RETURN TRIM(REGEXP_REPLACE(v_texto_sem_acentos, ' {2,}', ' '));
EXCEPTION
    WHEN OTHERS THEN
        RETURN p_texto;
END LIMPA_CARACTERES_ESPECIAIS;
