-- ProyectoPlataformaDigital.HASTAG definition

CREATE TABLE `HASTAG` (
  `idHASTAG` int NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idHASTAG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- ProyectoPlataformaDigital.USUARIO definition

CREATE TABLE `USUARIO` (
  `idUSUARIO` int NOT NULL,
  `nombre` varchar(150) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `fechaRegistro` date DEFAULT NULL,
  `pais` varchar(100) DEFAULT NULL,
  `tipo` enum('creador','administrador') NOT NULL,
  PRIMARY KEY (`idUSUARIO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- ProyectoPlataformaDigital.ADMINISTRADOR definition

CREATE TABLE `ADMINISTRADOR` (
  `nivelAcceso` int DEFAULT NULL,
  `sector` varchar(100) DEFAULT NULL,
  `areaResponsable` varchar(100) DEFAULT NULL,
  `idUSUARIO` int NOT NULL,
  PRIMARY KEY (`idUSUARIO`),
  CONSTRAINT `fk_ADMINISTRADOR_USUARIO1` FOREIGN KEY (`idUSUARIO`) REFERENCES `USUARIO` (`idUSUARIO`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- ProyectoPlataformaDigital.CREADOR definition

CREATE TABLE `CREADOR` (
  `numSeguidores` int DEFAULT NULL,
  `certificado` varchar(45) DEFAULT NULL,
  `ingresos` varchar(100) DEFAULT NULL,
  `numLikes` varchar(100) DEFAULT NULL,
  `idUSUARIO` int NOT NULL,
  PRIMARY KEY (`idUSUARIO`),
  CONSTRAINT `fk_CREADOR_USUARIO1` FOREIGN KEY (`idUSUARIO`) REFERENCES `USUARIO` (`idUSUARIO`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- ProyectoPlataformaDigital.SIGUE definition

CREATE TABLE `SIGUE` (
  `idUSUARIO` int NOT NULL,
  `idUSUARIO_sigue` int NOT NULL,
  PRIMARY KEY (`idUSUARIO`,`idUSUARIO_sigue`),
  KEY `fk_SIGUE_USUARIO2` (`idUSUARIO_sigue`),
  CONSTRAINT `fk_SIGUE_USUARIO1` FOREIGN KEY (`idUSUARIO`) REFERENCES `USUARIO` (`idUSUARIO`),
  CONSTRAINT `fk_SIGUE_USUARIO2` FOREIGN KEY (`idUSUARIO_sigue`) REFERENCES `USUARIO` (`idUSUARIO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- ProyectoPlataformaDigital.VIDEO definition

CREATE TABLE `VIDEO` (
  `idVIDEO` int NOT NULL,
  `titulo` varchar(255) DEFAULT NULL,
  `descripcion` text,
  `fechaPublicacion` date DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `idUSUARIO` int NOT NULL,
  `TIPO_idUSUARIO` int DEFAULT NULL,
  PRIMARY KEY (`idVIDEO`),
  KEY `fk_VIDEO_CREADOR1` (`idUSUARIO`),
  CONSTRAINT `fk_VIDEO_CREADOR1` FOREIGN KEY (`idUSUARIO`) REFERENCES `CREADOR` (`idUSUARIO`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- ProyectoPlataformaDigital.COMENTARIO definition

CREATE TABLE `COMENTARIO` (
  `numComentario` int NOT NULL,
  `fechaComentario` date DEFAULT NULL,
  `idUSUARIO` int NOT NULL,
  `VIDEO_idVIDEO` int NOT NULL,
  PRIMARY KEY (`numComentario`,`idUSUARIO`,`VIDEO_idVIDEO`),
  KEY `fk_COMENTARIO_USUARIO1` (`idUSUARIO`),
  KEY `fk_COMENTARIO_VIDEO1` (`VIDEO_idVIDEO`),
  CONSTRAINT `fk_COMENTARIO_USUARIO1` FOREIGN KEY (`idUSUARIO`) REFERENCES `USUARIO` (`idUSUARIO`),
  CONSTRAINT `fk_COMENTARIO_VIDEO1` FOREIGN KEY (`VIDEO_idVIDEO`) REFERENCES `VIDEO` (`idVIDEO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- ProyectoPlataformaDigital.MENCIONA definition

CREATE TABLE `MENCIONA` (
  `idVideo` int NOT NULL,
  `idUsuarioMenciona` int NOT NULL,
  PRIMARY KEY (`idVideo`,`idUsuarioMenciona`),
  KEY `fk_MENCIONA_USUARIO` (`idUsuarioMenciona`),
  CONSTRAINT `fk_MENCIONA_USUARIO` FOREIGN KEY (`idUsuarioMenciona`) REFERENCES `USUARIO` (`idUSUARIO`) ON DELETE CASCADE,
  CONSTRAINT `fk_MENCIONA_VIDEO` FOREIGN KEY (`idVideo`) REFERENCES `VIDEO` (`idVIDEO`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- ProyectoPlataformaDigital.REACCIONA definition

CREATE TABLE `REACCIONA` (
  `idVideo` int NOT NULL,
  `idUsuarioReacciona` int NOT NULL,
  `tipoReaccion` set('Me encanta','Like','Asombro','Divertido','No me gusta') NOT NULL DEFAULT 'No me gusta',
  `fechaReaccion` date DEFAULT NULL,
  PRIMARY KEY (`idVideo`,`idUsuarioReacciona`),
  KEY `fk_REACCIONA_USUARIO` (`idUsuarioReacciona`),
  CONSTRAINT `fk_REACCIONA_USUARIO` FOREIGN KEY (`idUsuarioReacciona`) REFERENCES `USUARIO` (`idUSUARIO`) ON DELETE CASCADE,
  CONSTRAINT `fk_REACCIONA_VIDEO` FOREIGN KEY (`idVideo`) REFERENCES `VIDEO` (`idVIDEO`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- ProyectoPlataformaDigital.TIENE definition

CREATE TABLE `TIENE` (
  `idVideo` int NOT NULL,
  `idHastag` int NOT NULL,
  PRIMARY KEY (`idVideo`,`idHastag`),
  KEY `fk_TIENE_HASTAG` (`idHastag`),
  CONSTRAINT `fk_TIENE_HASTAG` FOREIGN KEY (`idHastag`) REFERENCES `HASTAG` (`idHASTAG`) ON DELETE CASCADE,
  CONSTRAINT `fk_TIENE_VIDEO` FOREIGN KEY (`idVideo`) REFERENCES `VIDEO` (`idVIDEO`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;