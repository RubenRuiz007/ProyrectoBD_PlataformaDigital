
DELIMITER //
CREATE FUNCTION categoria_creador(idCreador INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
   DECLARE categoria VARCHAR(20);
	DECLARE numeroSeguidores int;
	
	SELECT c.numSeguidores
	into numeroSeguidores
	from CREADOR c
	where c.idUSUARIO  =idCreador;
	
	IF numeroSeguidores >= 500000 THEN
       SET categoria = 'Estrella';
   ELSEIF numeroSeguidores between 100000 and 500000 THEN
       SET categoria = 'Popular';
   ELSE
       SET categoria = 'En crecimiento';
   END IF;
   RETURN categoria;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION total_reacciones(p_idVideo INT)
RETURNS INT
DETERMINISTIC
BEGIN
   DECLARE v_total INT;
   SELECT COUNT(*)
	INTO v_total
	FROM REACCIONA
	WHERE idVideo = p_idVideo;
   RETURN v_total;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE info_creador(IN p_idUsuario INT)
BEGIN
	declare nombre varchar(50);
	declare seguidores int;
	declare rango varchar(20);
  SELECT
      u.nombre,
      c.numSeguidores,
      categoria_creador(c.numSeguidores) AS Rango_Plataforma
  into nombre,seguidores,rango
  FROM USUARIO u
  INNER JOIN CREADOR c ON u.idUSUARIO = c.idUSUARIO
  WHERE u.idUSUARIO = p_idUsuario;
	select nombre,seguidores,rango;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE sp_certificar_cuenta(IN p_idUsuario INT)
BEGIN
	if exists (select 1 from CREADOR c where c.IdUsuario=p_idUsuario) then
	    UPDATE CREADOR
	    SET certificado = 'Si'
	    WHERE idUSUARIO = p_idUsuario AND numSeguidores > 100000;
	else
		signal sqlstate '45000'
		set message_text='No existe el creador';
	end if;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_cambiar_area_admin(IN p_idUsuario INT, IN p_nuevaArea VARCHAR(100))
BEGIN
   UPDATE ADMINISTRADOR
   SET areaResponsable = p_nuevaArea
   WHERE idUSUARIO = p_idUsuario;
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER nuevo_seguidor
AFTER INSERT ON SIGUE
FOR EACH ROW
BEGIN
  UPDATE CREADOR
  SET numSeguidores = numSeguidores + 1
  WHERE idUSUARIO = NEW.idUSUARIO_sigue;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER reaccion_positiva
AFTER INSERT ON REACCIONA
FOR EACH ROW
BEGIN
  DECLARE idCreador INT;
   -- Si la reacción es positiva, actuamos:
  IF NEW.tipoReaccion IN ('Like', 'Me encanta') THEN
      -- 1. Buscamos de quién es el vídeo reaccionado
      SELECT idUSUARIO INTO idCreador FROM VIDEO WHERE idVIDEO = NEW.idVideo;
    
      -- 2. Le sumamos 1 a los likes totales de ese creador
      UPDATE CREADOR
      SET numLikes = numLikes + 1
      WHERE idUSUARIO = idCreador;
  END IF;
END //
DELIMITER ;