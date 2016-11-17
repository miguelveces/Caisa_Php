-- phpMyAdmin SQL Dump
-- version 4.0.10.7
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 16-08-2015 a las 08:30:07
-- Versión del servidor: 5.5.32-cll-lve
-- Versión de PHP: 5.4.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `planillas`
--


DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_talonarios_empleados`(IN `id_empresa` INT, IN `id_periodo` INT)
BEGIN
DECLARE idempleado   INT;
DECLARE coddesing VARCHAR(50);
DECLARE idempleadotmp  INT;
DECLARE monto VARCHAR(50);
DECLARE montopend VARCHAR(50);
DECLARE cont  INT;
DECLARE done2 INT DEFAULT 0;
DECLARE c_2 CURSOR FOR 	SELECT empleados.id_empleado,cod_descuento_ingreso,monto_periodo,monto_pendiente
						FROM empleados 
						INNER JOIN descuentos_ingresos_empleados ON empleados.id_empleado=descuentos_ingresos_empleados.id_empleado 
						INNER JOIN descuentos_ingresos ON descuentos_ingresos.id_descuento_ingreso=descuentos_ingresos_empleados.id_descuento_ingreso 
						WHERE empleados.id_empresa=id_empresa AND descuentos_ingresos_empleados.id_periodo=id_periodo
						ORDER BY 1;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done2 = 1;
INSERT INTO talonarios_empleados (id_empleado,numero_empleado,nombre_empleado, apellido_empleado,cedula_empleado, claveir, rataxhora,
id_empresa,nombre_empresa,
nombre_departamento,
id_seccion, nombre_seccion, 
id_periodo,  
horas_regular,horas_domingo, horas_feriado, horas_compensatorio, 
horas_extra1, horas_extra2, horas_extra3, horas_extra4, horas_extra5, 
horas_extra6, horas_extra7, horas_extra8, horas_extra9, horas_extra10, 
factor_reg, factor_dom, factor_fer, factor_com, 
factor1,factor2, factor3, factor4, factor5, 
factor6, factor7, factor8, factor9, factor10, 
horas_enferm, horas_ajuste, horas_ausen, seg_soc, seg_edu, isr, numero_cuenta, id_tipo_cuenta, id_banco)
SELECT
	 empleados.id_empleado,
     empleados.numero_empleado,
     empleados.nombre,
     empleados.apellido,
     empleados.cedula,
     empleados.clave_renta,
     empleados.rata_x_hora,
	 empresas.id_empresa,
     empresas.nombre_empresa,
     departamentos.nombre_departamento,
     secciones.id_seccion,
     secciones.nombre_seccion,
	 id_periodo, 
     registros_transacciones_empleados.horas_regular,
     registros_transacciones_empleados.horas_domingo,
     registros_transacciones_empleados.horas_feriado,
     registros_transacciones_empleados.horas_compensatorio,
     registros_transacciones_empleados.horas_extra1,
     registros_transacciones_empleados.horas_extra2,
     registros_transacciones_empleados.horas_extra3,
     registros_transacciones_empleados.horas_extra4,
     registros_transacciones_empleados.horas_extra5,
     registros_transacciones_empleados.horas_extra6,
     registros_transacciones_empleados.horas_extra7,
     registros_transacciones_empleados.horas_extra8,
     registros_transacciones_empleados.horas_extra9,
     registros_transacciones_empleados.horas_extra10,
     registros_transacciones_empleados.factor_reg,
     registros_transacciones_empleados.factor_dom,
     registros_transacciones_empleados.factor_fer,
     registros_transacciones_empleados.factor_com,
     registros_transacciones_empleados.factor1,
     registros_transacciones_empleados.factor2,
     registros_transacciones_empleados.factor3,
     registros_transacciones_empleados.factor4,
     registros_transacciones_empleados.factor5,
     registros_transacciones_empleados.factor6,
     registros_transacciones_empleados.factor7,
     registros_transacciones_empleados.factor8,
     registros_transacciones_empleados.factor9,
     registros_transacciones_empleados.factor10,
     registros_transacciones_empleados.horas_enferm,
     registros_transacciones_empleados.horas_ajuste,
     registros_transacciones_empleados.horas_ausen,
     impuestos_legales_empleados.monto_ss,
     impuestos_legales_empleados.monto_se,
	 impuestos_legales_empleados.monto_isr,
     cuentas_banco_empleados.numero_cuenta,
     cuentas_banco_empleados.id_tipo_cuenta,
     cuentas_banco_empleados.id_banco
FROM
empresas empresas LEFT OUTER JOIN empleados empleados ON empresas.id_empresa = empleados.id_empresa
     LEFT OUTER JOIN secciones secciones ON empleados.id_seccion = secciones.id_seccion
     LEFT OUTER JOIN impuestos_legales_empleados impuestos_legales_empleados ON empleados.id_empleado = impuestos_legales_empleados.id_empleado
     LEFT OUTER JOIN registros_transacciones_empleados registros_transacciones_empleados ON empleados.id_empleado = registros_transacciones_empleados.id_empleado
     LEFT OUTER JOIN cuentas_banco_empleados cuentas_banco_empleados ON empleados.id_empleado = cuentas_banco_empleados.id_empleado
     LEFT OUTER JOIN departamentos departamentos ON secciones.id_departamento = departamentos.id_departamento
WHERE
     empresas.id_empresa =id_empresa
 AND impuestos_legales_empleados.id_periodo = id_periodo
 AND registros_transacciones_empleados.id_periodo = id_periodo;
SET cont =0;
SET idempleadotmp =0;
			OPEN c_2;
	REPEAT
	FETCH c_2 INTO idempleado,coddesing,monto,montopend;
	
	
		IF idempleadotmp=0 OR idempleado!=idempleadotmp THEN
			SET cont = 1;
		END IF;

		IF NOT done2 THEN
			CASE cont
				WHEN 1 THEN
					UPDATE  talonarios_empleados SET cod1=coddesing, monto1=monto ,monto_pend1=montopend
					WHERE talonarios_empleados.id_empleado=idempleado AND talonarios_empleados.id_periodo=id_periodo;
				WHEN 2 THEN
					UPDATE  talonarios_empleados SET cod2=coddesing, monto2=monto ,monto_pend2=montopend
					WHERE talonarios_empleados.id_empleado=idempleado AND talonarios_empleados.id_periodo=id_periodo;
				WHEN 3 THEN
					UPDATE  talonarios_empleados SET cod3=coddesing, monto3=monto ,monto_pend3=montopend
					WHERE talonarios_empleados.id_empleado=idempleado AND talonarios_empleados.id_periodo=id_periodo;
				WHEN 4 THEN
					UPDATE  talonarios_empleados SET cod4=coddesing, monto4=monto ,monto_pend4=montopend
					WHERE talonarios_empleados.id_empleado=idempleado AND talonarios_empleados.id_periodo=id_periodo;
				WHEN 5 THEN
					UPDATE  talonarios_empleados SET cod5=coddesing, monto5=monto ,monto_pend5=montopend
					WHERE talonarios_empleados.id_empleado=idempleado AND talonarios_empleados.id_periodo=id_periodo;
				WHEN 6 THEN
					UPDATE  talonarios_empleados SET cod6=coddesing, monto6=monto ,monto_pend6=montopend
					WHERE talonarios_empleados.id_empleado=idempleado AND talonarios_empleados.id_periodo=id_periodo;
				WHEN 7 THEN
					UPDATE  talonarios_empleados SET cod7=coddesing, monto7=monto ,monto_pend7=montopend
					WHERE talonarios_empleados.id_empleado=idempleado AND talonarios_empleados.id_periodo=id_periodo;
				WHEN 8 THEN
					UPDATE  talonarios_empleados SET cod8=coddesing, monto8=monto ,monto_pend8=montopend
					WHERE talonarios_empleados.id_empleado=idempleado AND talonarios_empleados.id_periodo=id_periodo;
				WHEN 9 THEN
					UPDATE  talonarios_empleados SET cod9=coddesing, monto9=monto ,monto_pend9=montopend
					WHERE talonarios_empleados.id_empleado=idempleado AND talonarios_empleados.id_periodo=id_periodo;
				WHEN 10 THEN
					UPDATE  talonarios_empleados SET cod10=coddesing, monto10=monto ,monto_pend10=montopend
					WHERE talonarios_empleados.id_empleado=idempleado AND talonarios_empleados.id_periodo=id_periodo;
				ELSE BEGIN END; 
			END CASE;	   
		END IF;
		
		SET idempleadotmp=idempleado;
		SET cont = cont + 1;
	
	UNTIL done2 END REPEAT;
	CLOSE c_2;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bancos`
--

CREATE TABLE IF NOT EXISTS `bancos` (
  `id_banco` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_banco` varchar(100) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_banco`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Volcado de datos para la tabla `bancos`
--

INSERT INTO `bancos` (`id_banco`, `nombre_banco`, `fecha_creacion`, `id_usuario`) VALUES
(1, 'BANCO GENERAL', '2015-03-27 07:00:15', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cargos`
--

CREATE TABLE IF NOT EXISTS `cargos` (
  `id_cargo` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_cargo` varchar(100) DEFAULT NULL,
  `codigo_cargo` varchar(100) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_cargo`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=41 ;

--
-- Volcado de datos para la tabla `cargos`
--

INSERT INTO `cargos` (`id_cargo`, `nombre_cargo`, `codigo_cargo`, `fecha_creacion`, `id_usuario`) VALUES
(1, 'ASISTENTE CONTABLE', '0001', '2015-04-21 18:27:26', 1),
(2, 'AUYDANTE GENERAL', '0002', '2015-04-21 18:27:26', 1),
(3, 'ASIST ADMINISTRATIVA', '0003', '2015-04-21 18:27:26', 1),
(4, 'OFICINISTA', '0004', '2015-04-21 18:27:26', 1),
(5, 'ASISTENTE  ADM.', '0005', '2015-04-21 18:27:26', 1),
(6, 'VETERINARIO', '0006', '2015-04-21 18:27:27', 1),
(7, 'SEGURIDAD', '0007', '2015-04-21 18:27:27', 1),
(8, 'OPERADOR III', '0008', '2015-04-21 18:27:27', 1),
(9, 'ASIST ADMINISTRATIVO', '0009', '2015-04-21 18:27:27', 1),
(10, 'LABORES DE MATANZA', '0010', '2015-04-21 18:27:27', 1),
(11, 'SUPERVISOR DE PLANTA', '0011', '2015-04-21 18:27:27', 1),
(12, 'ADMINIST. FINCA', '0012', '2015-04-21 18:27:27', 1),
(13, 'SOLDADOR', '0013', '2015-04-21 18:27:27', 1),
(14, 'CONDUCTOR', '0014', '2015-04-21 18:27:27', 1),
(15, 'AYUDANTE  GENERAL', '0015', '2015-04-21 18:27:27', 1),
(16, 'TRAB. MANUAL', '0016', '2015-04-21 18:27:27', 1),
(17, 'T. GENERALES', '0017', '2015-04-21 18:27:27', 1),
(18, 'TRAB. GENERALES', '0018', '2015-04-21 18:27:27', 1),
(19, 'TRABAJOS GENERALES', '0019', '2015-04-21 18:27:27', 1),
(20, 'SUPERVISOR', '0020', '2015-04-21 18:27:28', 1),
(21, 'ELECTRICISTA', '0021', '2015-04-21 18:27:28', 1),
(22, 'ENCARGADO DE PLANTA', '0022', '2015-04-21 18:27:28', 1),
(23, 'SUPERVISOR DE FINCA', '0023', '2015-04-21 18:27:28', 1),
(24, 'MECANICO GENERAL DE FLOTA', '0024', '2015-04-21 18:27:28', 1),
(25, 'GESTACION', '0025', '2015-04-21 18:27:28', 1),
(26, 'MATERNIDAD', '0026', '2015-04-21 18:27:28', 1),
(27, 'PRE-CEBA', '0027', '2015-04-21 18:27:28', 1),
(28, 'MANTENIMIENTO', '0028', '2015-04-21 18:27:28', 1),
(29, 'PRE-CEBA Y REMPLAZO', '0029', '2015-04-21 18:27:28', 1),
(30, 'CEBA', '0030', '2015-04-21 18:27:28', 1),
(31, 'PRODUCCION DE FRUTAS', '0031', '2015-04-21 18:27:28', 1),
(32, 'GANADERIA', '0032', '2015-04-21 18:27:28', 1),
(33, 'SALA', '0033', '2015-04-21 18:27:29', 1),
(34, 'CORRALES Y RECEPCION', '0034', '2015-04-21 18:27:29', 1),
(35, 'CARNE HARINA', '0035', '2015-04-21 18:27:29', 1),
(36, 'LABORATORIO', '0036', '2015-04-21 18:27:29', 1),
(37, 'LAVADOR', '0037', '2015-04-21 18:27:29', 1),
(38, 'AYUDANTE  DE MECANICO DE FLOTA', '0038', '2015-04-21 18:27:29', 1),
(39, 'SOLDADOR GRUPO CAISA', '0039', '2015-04-21 18:27:29', 1),
(40, 'JARDINERIA', '0040', '2015-04-21 18:27:29', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuentas_banco_empleados`
--

CREATE TABLE IF NOT EXISTS `cuentas_banco_empleados` (
  `id_cuenta_banco_empleado` int(11) NOT NULL AUTO_INCREMENT,
  `id_empleado` int(11) DEFAULT NULL,
  `numero_empleado` varchar(100) DEFAULT NULL,
  `numero_cuenta` varchar(100) DEFAULT NULL,
  `id_tipo_cuenta` int(11) DEFAULT NULL,
  `nombre_tipo_cuenta` varchar(100) DEFAULT NULL,
  `tipo_tranferencia` varchar(100) DEFAULT NULL,
  `id_banco` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_cuenta_banco_empleado`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

--
-- Volcado de datos para la tabla `cuentas_banco_empleados`
--

INSERT INTO `cuentas_banco_empleados` (`id_cuenta_banco_empleado`, `id_empleado`, `numero_empleado`, `numero_cuenta`, `id_tipo_cuenta`, `nombre_tipo_cuenta`, `tipo_tranferencia`, `id_banco`) VALUES
(1, 6, '00002', '0403010000001', 4, 'CUENTAS AHORROS', 'ACH', 1),
(2, 5, '00019', '0403010000002', 4, 'CUENTAS AHORROS', 'ACH', 1),
(3, 7, '00028', '0403010000003', 4, 'CUENTAS AHORROS', 'ACH', 1),
(4, 10, '00030', '0403010000004', 4, 'CUENTAS AHORROS', 'ACH', 1),
(5, 9, '00032', '0403010000005', 4, 'CUENTAS AHORROS', 'ACH', 1),
(6, 11, '00035', '0403010000006', 4, 'CUENTAS AHORROS', 'ACH', 1),
(7, 4, '00038', '0403010000007', 4, 'CUENTAS AHORROS', 'ACH', 1),
(8, 8, '00039', '0403010000008', 4, 'CUENTAS AHORROS', 'ACH', 1),
(9, 18, '00002', '0401027778889', 4, 'CUENTAS AHORROS', 'ACH', 1),
(10, 13, '00004', '0401026667779', 4, 'CUENTAS AHORROS', 'ACH', 1),
(11, 17, '00006', '0401025556669', 4, 'CUENTAS AHORROS', 'ACH', 1),
(12, 16, '00007', '0401024445559', 4, 'CUENTAS AHORROS', 'ACH', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamentos`
--

CREATE TABLE IF NOT EXISTS `departamentos` (
  `id_departamento` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_departamento` varchar(100) DEFAULT NULL,
  `codigo_departamento` varchar(100) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_departamento`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=30 ;

--
-- Volcado de datos para la tabla `departamentos`
--

INSERT INTO `departamentos` (`id_departamento`, `nombre_departamento`, `codigo_departamento`, `fecha_creacion`, `id_usuario`) VALUES
(1, 'ADMINISTRACION', '0001', '2015-04-21 17:30:41', 1),
(2, 'PLANTA DE SACRIFICIO', '0002', '2015-04-21 17:30:41', 1),
(3, 'CADASA', '0003', '2015-04-21 17:30:41', 1),
(4, 'MARGARITA', '0004', '2015-04-21 17:30:41', 1),
(5, 'VERVEL', '0005', '2015-04-21 17:30:41', 1),
(6, 'EMPERADOR 1', '0006', '2015-04-21 17:30:41', 1),
(7, 'PESE', '0007', '2015-04-21 17:30:41', 1),
(8, '4 ASES', '0008', '2015-04-21 17:30:41', 1),
(9, 'PLANTA VIEJA', '0009', '2015-04-21 17:30:41', 1),
(10, 'CABUYA', '0010', '2015-04-21 17:30:41', 1),
(11, 'TRANSPORTE', '0011', '2015-04-21 17:30:41', 1),
(12, 'FINCA VILLA NINA', '0012', '2015-04-21 17:30:41', 1),
(13, 'EMPERADOR 2', '0013', '2015-04-21 17:30:42', 1),
(14, 'FINCA AGROCERDO', '0014', '2015-04-21 17:30:42', 1),
(15, 'FINCA CHIRIQUI', '0015', '2015-04-21 17:30:42', 1),
(16, 'OFICCINA PANAMA', '0016', '2015-04-21 17:30:42', 1),
(17, 'ADMINISTRACION CEBA', '0017', '2015-04-21 17:30:42', 1),
(18, 'FINCA EL MACANO', '0018', '2015-04-21 17:30:42', 1),
(19, 'FINCA POTRERILLO', '0019', '2015-04-21 17:30:42', 1),
(20, 'MARIA DE LOS ANGELES', '0020', '2015-04-21 17:30:42', 1),
(21, 'FALDARES', '0021', '2015-04-21 17:30:42', 1),
(22, 'AGROREY', '0022', '2015-04-21 17:30:42', 1),
(23, 'ENRIQUI REAL', '0023', '2015-04-21 17:30:42', 1),
(24, 'MANTENIMIENTO', '0024', '2015-04-21 17:30:42', 1),
(25, 'PLANTA', '0025', '2015-04-21 17:30:42', 1),
(26, 'SALA', '0026', '2015-04-21 17:30:42', 1),
(27, 'CARNE HARINA', '0027', '2015-04-21 17:30:43', 1),
(28, 'VENTAS', '0028', '2015-04-21 17:30:43', 1),
(29, 'DESHUESE', '0029', '2015-04-21 17:30:43', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `descuentos_ingresos`
--

CREATE TABLE IF NOT EXISTS `descuentos_ingresos` (
  `id_descuento_ingreso` int(11) NOT NULL AUTO_INCREMENT,
  `cod_descuento_ingreso` varchar(100) DEFAULT NULL,
  `nombre_descuento_ingreso` varchar(100) DEFAULT NULL,
  `tipo` varchar(100) DEFAULT NULL,
  `numero_cuenta` varchar(100) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_descuento_ingreso`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Volcado de datos para la tabla `descuentos_ingresos`
--

INSERT INTO `descuentos_ingresos` (`id_descuento_ingreso`, `cod_descuento_ingreso`, `nombre_descuento_ingreso`, `tipo`, `numero_cuenta`, `fecha_creacion`, `id_usuario`) VALUES
(1, 'BG', 'CUENTA COBRAR', 'INGRESOS', '', '2015-04-07 19:42:45', 1),
(2, 'BAC', 'CUENTA DE CARRO', 'DESCUENTO', '', '2015-04-07 19:42:46', 1),
(3, '1-LG', 'CUENTA COBRAR', 'DESCUENTO', '', '2015-04-08 21:06:46', 2),
(4, 'COPERA', 'CUENTA COBRAR', 'DESCUENTO', '', '2015-04-08 21:07:35', 2),
(5, 'COPER3', 'CUENTA COBRAR', 'DESCUENTO', '', '2015-04-08 21:07:44', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `descuentos_ingresos_empleados`
--

CREATE TABLE IF NOT EXISTS `descuentos_ingresos_empleados` (
  `id_descuento_ingreso_empleado` int(11) NOT NULL AUTO_INCREMENT,
  `numero_cliente` varchar(100) DEFAULT NULL,
  `numero_cuenta` varchar(100) DEFAULT NULL,
  `id_empleado` int(11) DEFAULT NULL,
  `numero_empleado` varchar(100) DEFAULT NULL,
  `id_descuento_ingreso` int(11) DEFAULT NULL,
  `monto_mes` varchar(100) DEFAULT NULL,
  `monto_periodo` varchar(100) DEFAULT NULL,
  `afecta_diciembre` varchar(100) DEFAULT NULL,
  `prioridad` varchar(100) DEFAULT NULL,
  `tipo` varchar(100) DEFAULT NULL,
  `frecuencia` varchar(100) DEFAULT NULL,
  `monto_urgente` varchar(100) DEFAULT NULL,
  `monto_original` varchar(100) DEFAULT NULL,
  `monto_pendiente` varchar(100) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL,
  `referencia` varchar(100) DEFAULT NULL,
  `id_periodo` int(11) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_descuento_ingreso_empleado`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Volcado de datos para la tabla `descuentos_ingresos_empleados`
--

INSERT INTO `descuentos_ingresos_empleados` (`id_descuento_ingreso_empleado`, `numero_cliente`, `numero_cuenta`, `id_empleado`, `numero_empleado`, `id_descuento_ingreso`, `monto_mes`, `monto_periodo`, `afecta_diciembre`, `prioridad`, `tipo`, `frecuencia`, `monto_urgente`, `monto_original`, `monto_pendiente`, `estado`, `referencia`, `id_periodo`, `fecha_creacion`, `id_usuario`) VALUES
(1, '', '', 18, '00002', 1, '10.00', '5.00', 'NO', '4', '3', '', '', '50.00', '50.00', 1, '', 3, '2015-05-22 16:55:15', 2),
(2, '', '', 18, '00002', 2, '20.00', '10.00', 'NO', '4', '3', '', '', '100.00', '100.00', 1, '', 3, '2015-05-22 16:56:09', 2),
(3, '', '', 13, '00004', 4, '14.00', '7.00', 'NO', '4', '3', '', '', '200.00', '200.00', 1, '', 3, '2015-05-22 16:56:56', 2),
(4, '', '', 13, '00004', 1, '10.00', '5.00', 'NO', '4', '3', '', '', '100.00', '100.00', 1, '', 3, '2015-05-22 16:57:54', 2),
(5, '', '', 17, '00006', 3, '50.00', '25.00', 'NO', '4', '3', '', '', '500.00', '500.00', 1, '', 3, '2015-05-22 20:03:14', 2),
(6, '', '', 16, '00007', 1, '100.00', '50.00', 'NO', '4', '3', '', '', '1000.00', '1000.00', 1, '', 3, '2015-05-22 20:04:11', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `descuentos_ingresos_empleados_detalles`
--

CREATE TABLE IF NOT EXISTS `descuentos_ingresos_empleados_detalles` (
  `id_descuento_ingreso_empleado_detalle` int(11) NOT NULL AUTO_INCREMENT,
  `id_descuento_ingreso_empleado` int(11) DEFAULT NULL,
  `monto_mes` varchar(100) DEFAULT NULL,
  `monto_periodo` varchar(100) DEFAULT NULL,
  `monto_original` varchar(100) DEFAULT NULL,
  `monto_pendiente` varchar(100) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL,
  `id_periodo` int(11) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_descuento_ingreso_empleado_detalle`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Volcado de datos para la tabla `descuentos_ingresos_empleados_detalles`
--

INSERT INTO `descuentos_ingresos_empleados_detalles` (`id_descuento_ingreso_empleado_detalle`, `id_descuento_ingreso_empleado`, `monto_mes`, `monto_periodo`, `monto_original`, `monto_pendiente`, `estado`, `id_periodo`, `fecha_creacion`, `id_usuario`) VALUES
(1, 1, '10.00', '5.00', '50.00', '50.00', 1, 3, '2015-05-22 16:55:15', 2),
(2, 2, '20.00', '10.00', '100.00', '100.00', 1, 3, '2015-05-22 16:56:09', 2),
(3, 3, '14.00', '7.00', '200.00', '200.00', 1, 3, '2015-05-22 16:56:56', 2),
(4, 4, '10.00', '5.00', '100.00', '100.00', 1, 3, '2015-05-22 16:57:54', 2),
(5, 5, '50.00', '25.00', '500.00', '500.00', 1, 3, '2015-05-22 20:03:14', 2),
(6, 6, '100.00', '50.00', '1000.00', '1000.00', 1, 3, '2015-05-22 20:04:11', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dias_feriados`
--

CREATE TABLE IF NOT EXISTS `dias_feriados` (
  `id_dia_feriado` int(11) NOT NULL AUTO_INCREMENT,
  `fecha_dia_feriado` date DEFAULT NULL,
  `celebracion` varchar(100) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_dia_feriado`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Volcado de datos para la tabla `dias_feriados`
--

INSERT INTO `dias_feriados` (`id_dia_feriado`, `fecha_dia_feriado`, `celebracion`, `fecha_creacion`, `id_usuario`) VALUES
(1, '2015-05-01', 'Dia del tarbajo', '2015-04-01 07:19:29', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleados`
--

CREATE TABLE IF NOT EXISTS `empleados` (
  `id_empleado` int(11) NOT NULL AUTO_INCREMENT,
  `numero_empleado` varchar(100) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `cedula` varchar(100) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `seguro_social` varchar(100) DEFAULT NULL,
  `tipo_sangre` varchar(100) DEFAULT NULL,
  `id_estado_empleado` int(11) DEFAULT NULL,
  `id_genero` int(11) DEFAULT NULL,
  `id_estado_civil` int(11) DEFAULT NULL,
  `id_nacionalidad` int(11) DEFAULT NULL,
  `sindicato` int(11) DEFAULT NULL,
  `fecha_venc_carnet` date DEFAULT NULL,
  `clave_renta` varchar(100) DEFAULT NULL,
  `forma_pago` varchar(100) DEFAULT NULL,
  `salario` varchar(100) DEFAULT NULL,
  `rata_x_hora` varchar(100) DEFAULT NULL,
  `horas_x_periodo` varchar(100) DEFAULT NULL,
  `fecha_ingreso` date DEFAULT NULL,
  `fecha_prox_vacaciones` date DEFAULT NULL,
  `fecha_venc_contrato` date DEFAULT NULL,
  `pago_efectivo` int(11) DEFAULT NULL,
  `frecuencia_pago` varchar(100) DEFAULT NULL,
  `isr_gasto` int(11) DEFAULT NULL,
  `fecha_terminacion` date DEFAULT NULL,
  `id_cargo` int(11) DEFAULT NULL,
  `id_seccion` int(11) DEFAULT NULL,
  `id_empresa` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_empleado`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=315 ;

--
-- Volcado de datos para la tabla `empleados`
--

INSERT INTO `empleados` (`id_empleado`, `numero_empleado`, `nombre`, `apellido`, `cedula`, `fecha_nacimiento`, `seguro_social`, `tipo_sangre`, `id_estado_empleado`, `id_genero`, `id_estado_civil`, `id_nacionalidad`, `sindicato`, `fecha_venc_carnet`, `clave_renta`, `forma_pago`, `salario`, `rata_x_hora`, `horas_x_periodo`, `fecha_ingreso`, `fecha_prox_vacaciones`, `fecha_venc_contrato`, `pago_efectivo`, `frecuencia_pago`, `isr_gasto`, `fecha_terminacion`, `id_cargo`, `id_seccion`, `id_empresa`) VALUES
(4, '00038', 'ORLANDO', 'CASTILLO', '4-740-1605', '1982-07-01', '4-740-1605', '', 1, 1, 1, 1, 0, '0000-00-00', 'E-2', '', '336.97', '1.62', '208', '2014-05-08', '0000-00-00', '0000-00-00', 1, '', 0, '0000-00-00', 28, 28, 5),
(5, '00019', 'KEVIN', 'FUENTES', '4-749-2395', '1989-05-30', '9999-999', '', 1, 1, 1, 1, 0, '0000-00-00', 'A-0', '', '359.99', '1.73', '208', '2010-01-02', '0000-00-00', '0000-00-00', 1, '', 0, '0000-00-00', 27, 28, 5),
(6, '00002', 'TOMAS', 'GALLARDO S.', '4-151-29', '1964-10-05', '248-1978', '', 1, 1, 1, 1, 0, '0000-00-00', '', '', '359.99', '1.73', '208', '2006-05-01', '0000-00-00', '0000-00-00', 1, '', 0, '0000-00-00', 26, 28, 5),
(7, '00028', 'NELSON', 'GUERRA SALINA', '4-762-1884', '1992-03-20', '4-762-1884', '', 1, 1, 1, 1, 0, '0000-00-00', '', '', '359.99', '1.73', '208', '2011-05-01', '0000-00-00', '0000-00-00', 1, '', 0, '0000-00-00', 26, 28, 5),
(8, '00039', 'AGUSTIN', 'JIMENEZ ABREGO', '1-727-893', '1992-05-27', '1-727-893', '', 1, 1, 1, 1, 0, '0000-00-00', 'E-2', '', '336.97', '1.62', '208', '2014-07-07', '0000-00-00', '0000-00-00', 1, '', 0, '0000-00-00', 15, 29, 5),
(9, '00032', 'EDUARDO', 'MOJICA GONZALEZ', '7-257-270', '1972-11-03', '4-257-270', '', 1, 1, 1, 1, 0, '0000-00-00', '', '', '418.09', '2.01', '208', '1999-10-01', '0000-00-00', '0000-00-00', 1, '', 0, '0000-00-00', 25, 28, 5),
(10, '00030', 'RIGOBERTO', 'SAMUDIO QUINTERO', '1-717-1086', '1987-01-22', '99-9999', '', 1, 1, 1, 1, 0, '0000-00-00', 'E-3', '', '359.99', '1.73', '208', '2011-05-16', '0000-00-00', '0000-00-00', 1, '', 0, '0000-00-00', 26, 28, 5),
(11, '00035', 'FAUSTINO LEONIDO', 'VEGA GUERRA', '4-254-4', '1972-07-31', '999-9999', 'O+', 1, 1, 1, 1, 0, '0000-00-00', 'E-3', '', '336.97', '1.62', '208', '2013-10-01', '0000-00-00', '0000-00-00', 1, '', 0, '0000-00-00', 2, 28, 5),
(13, '00004', 'ROSA EVELIA', 'MARTINEZ', '9-125-1252', '1961-05-11', '15-0559', '', 1, 2, 1, 1, 0, '0000-00-00', 'A-0', '', '336.97', '1.62', '208', '2009-01-02', '0000-00-00', '0000-00-00', 1, '', 0, '0000-00-00', 2, 10, 6),
(16, '00007', 'BASILIDES', 'RODRIGUEZ', '2-102-2071', '1965-06-30', '2-102-2071', '', 1, 1, 1, 1, 0, '0000-00-00', 'E-3', '', '336.97', '1.62', '208', '2011-03-16', '0000-00-00', '0000-00-00', 0, '', 0, '0000-00-00', 2, 10, 6),
(17, '00006', 'CATALINO', 'RODRIGUEZ MAGALLON', '9999-999', '1978-11-25', '9999-999', '', 1, 1, 1, 1, 0, '0000-00-00', 'A-0', '', '336.97', '1.62', '208', '2010-01-02', '0000-00-00', '0000-00-00', 0, '', 0, '0000-00-00', 2, 10, 6),
(18, '00002', 'DIDIMO IVAN', 'VALDEZ', '9999-999', '1973-05-28', '9999-999', '', 1, 1, 1, 1, 0, '0000-00-00', 'A-0', '', '390.01', '1.87', '208', '2007-09-01', '0000-00-00', '0000-00-00', 0, '', 0, '0000-00-00', 2, 10, 6),
(19, '00028', 'JOSE MANUEL ', 'ABREGO BEJENARO', '4-804-2115', '0000-00-00', '4-804-2115', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-4', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', 2, 27, 4),
(20, '00027', 'SANTIAGO', 'ABREGO GARAY', '1-728-1257', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-5', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', 2, 27, 4),
(21, '00032', 'TOMAS EDUARDO', 'CABALLERO SIANG', '4-758-11', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-1', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', 2, 27, 4),
(22, '00025', 'LEONARDO', 'CONCEPCION RIOS', '4-257-237', '0000-00-00', '363-6416', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '374.99', '1.80', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', 2, 27, 4),
(23, '00031', 'LEONARDO CESAR', 'CONCEPCION TUGRI', '4-791-1823', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', 2, 27, 4),
(24, '00018', 'CELESTINO', 'MONTANA MONTESUMO', '4-764-1724', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '359.99', '1.73', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', 2, 27, 4),
(25, '00012', 'JOSE MANUEL ', 'SANCHEZ', '4-167-508', '0000-00-00', '202-7094', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '374.99', '1.80', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', 2, 27, 4),
(26, '00049', 'RODOLFO', 'ABREGO NUNEZ', '9-97-2291', '0000-00-00', '221-0482', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'C-0', NULL, '539.99', '2.59', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 7, 2),
(27, '00142', 'GABRIEL', 'ABREGO SMITH', '1-726-224', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-1', NULL, '500', '2.4', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(28, '00047', 'DOMINGO', 'ALMANZA', '6-89-126', '0000-00-00', '181-7203', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '650.01', '3.12', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 7, 2),
(29, '00172', 'MILLER', 'ANGULO HURTADO', 'P-1111777788', '0000-00-00', '547-3434', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-2', NULL, '500', '2.4', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 2),
(30, '00212', 'OSCAR RUBEN', 'ARISPE GARCIA', '8-840-725', '0000-00-00', '8-840-725', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(31, '00167', 'KELLYS DEL ROSARIO', 'BARRERA ARAUZ', '8-501-222', '0000-00-00', '8-501-222', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'E-3', NULL, '510', '2.45', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 24, 2),
(32, '00237', 'ELISANDRO', 'BARRERA MORA', '8-710-930', '0000-00-00', '8-710-930', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-1', NULL, '500', '2.4', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 2),
(33, '00093', 'NICOMEDES', 'BELLIDO M.', '9-128-874', '0000-00-00', '152-3571', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '799.99', '3.84', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 22, 2),
(34, '00059', 'JAIME AUGUSTO', 'BERNAL TORRES', '2-86-452', '0000-00-00', '122-5411', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-4', NULL, '500', '2.4', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 22, 2),
(35, '00151', 'YAIR LENNIN', 'BOYCE BARSALLO', '8-467-686', '0000-00-00', '8-467-686', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-2', NULL, '500', '2.4', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 2),
(36, '00035', 'CEDENO', 'CARPINTERO', '4-783-2153', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '539.99', '2.59', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(37, '00205', 'FRANCISCO', 'CARPINTERO', '4-750-214', '0000-00-00', '303-8176', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-1', NULL, '650.01', '3.12', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(38, '00148', 'MARCO', 'CARPINTERO', '4-791-302', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '500', '2.4', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 6, 2),
(39, '00117', 'FAUSTINO', 'CARPINTERO C.', '4-769-2398', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '520', '2.5', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(40, '00166', 'FLORENCIO', 'CARPINTERO C.', '4-769-2405', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '500', '2.4', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 7, 2),
(41, '00144', 'ALFREDO', 'CARPINTERO CORTEZ', '4-797-1325', '0000-00-00', '4-797-1325', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '500', '2.4', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(42, '00152', 'AMADO', 'CARPINTERO JIMENEZ', '4-793-1079', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '500', '2.4', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(43, '00126', 'OURIEL VIRGILIO', 'CARRASCO RODRIGUEZ', '8-747-156', '0000-00-00', '8-747-156', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-3', NULL, '650.01', '3.12', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(44, '00228', 'MAIKOL STIP', 'CASTILLERO ESPINOSA', '8-811-1029', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(45, '00222', 'MARIA GUADALUPE', 'CEDENO DE LEON', '8-287-589', '0000-00-00', '8-287-589', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'E-1', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 22, 2),
(46, '00186', 'MAIKEN JOVANI', 'CHIRU ARAUZ', '8-835-1966', '0000-00-00', '8-835-1966', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-1', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 22, 2),
(47, '00213', 'LOPEZ LORENZO', 'CHUITO TROTMAN', '1-26-631', '0000-00-00', '1-26-631', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-0', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 22, 2),
(48, '00236', 'MANUEL', 'CLARA CARPINTERO', '4-783-2190', '0000-00-00', '4-783-2190', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-6', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(49, '00052', 'ABRAHAN', 'DIAZ ', '9-115-553', '0000-00-00', '065-5601', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-5', NULL, '625', '3', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(50, '00004', 'OSWALDO', 'DIAZ ', '8-259-422', '0000-00-00', '125-1445', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'C-3', NULL, '1999.99', '9.61', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 2),
(51, '00223', 'HERNAN', 'ESPINOSA', '6-708-2278', '0000-00-00', '6-708-2278', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(52, '00107', 'SATURNINO', 'ESPINOSA FRANCO', '8-336-48', '0000-00-00', '36-6039', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-3', NULL, '539.99', '2.59', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(53, '00104', 'RAUL', 'ESPINOSA MARIN', '9-175-667', '0000-00-00', '36-6039', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-2', NULL, '539.99', '2.59', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 7, 2),
(54, '00202', 'FIDEL', 'GALLARDO', '4-728-2323', '0000-00-00', '248-8055', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '500', '2.4', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 22, 2),
(55, '00141', 'MIGUEL ANTONIO', 'GONZALEZ CERVANTES', '8-759-1641', '0000-00-00', '8-759-1641', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-4', NULL, '600', '2.88', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 23, 2),
(56, '00179', 'ARCELIO', 'GONZALEZ GONZALEZ', '9-726-1834', '0000-00-00', '9-726-1834', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 23, 2),
(57, '00162', 'GILBERTO ANTONIO', 'GONZALEZ ROBINSON', '8-886-473', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '500', '2.4', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(58, '00138', 'MARCOS ANTONIO', 'GONZALEZ ROBINSON', '8-854-331', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-0', NULL, '510', '2.45', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(59, '00046', 'FRANKLIN ANEL', 'GRAJALES', '8-859-787', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '650.01', '3.12', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(60, '00207', 'RICARDO', 'GUEVARA', '8-257-484', '0000-00-00', '278-3151', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-1', NULL, '799.99', '3.84', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 6, 2),
(61, '00215', 'GERONIMO', 'GUILLEN GARCIA', '4-752-1548', '0000-00-00', '4-752-1548', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(62, '00233', 'ORLANDO ANTONIO', 'LOPEZ BETHANCOURT', '8-277-141', '0000-00-00', '8-277-141', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '699.99', '3.36', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 18, 2),
(63, '00221', 'RODRIGO', 'LOPEZ ROBLES', '4-804-1113', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-1', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(64, '00195', 'YUJER', 'LOPEZ ROBLES', '4-816-989', '0000-00-00', '4-816-989', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 7, 2),
(65, '00238', 'ALEX', 'LORENZO BAKER', '1-53-190', '0000-00-00', '1-53-190', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-2', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 22, 2),
(66, '00153', 'EDILBERTO ANTONIO', 'MARQUEZ NAVARRO', '2-733-2391', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '500', '2.4', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(67, '00174', 'ISAAC', 'MARTINEZ MARTINEZ', '9-734-2127', '0000-00-00', '9-734-2127', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '525', '2.52', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 18, 2),
(68, '00191', 'JOSE LUIS', 'MEDINA RIVAS', '8-865-81', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(69, '00120', 'LUIS', 'MONTENEGRO', '8-789-1018', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '550', '2.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 2),
(70, '00231', 'ABDIEL', 'MONTEZUMA ANDRADE', '4-805-740', '0000-00-00', '4-805-740', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(71, '00031', 'ROSA MARIA', 'MORA AGUILAR', '4-126-2039', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'C-2', NULL, '525', '2.52', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 22, 2),
(72, '00112', 'JORGE LUIS', 'MORENO OJO', '8-716-524', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '539.99', '2.59', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(73, '00168', 'SHINDY DEL CARMEN', 'MUNOZ MOJICA', '8-495-86', '0000-00-00', '8-495-86', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-1', NULL, '950', '4.56', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 22, 2),
(74, '00210', 'CAMILO', 'NUNEZ', '8-751-2065', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-1', NULL, '575', '2.76', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(75, '00130', 'BENIDO', 'PEREZ ALMANZA', '6-706-2289', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '510', '2.45', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 7, 2),
(76, '00135', 'IRVING ISAAC', 'PEREZ MARTINEZ', '8-729-2159', '0000-00-00', '8-729-2159', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '510', '2.45', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 2),
(77, '00181', 'JERONIMITO', 'QUIROZ GIL', '8-189-455', '0000-00-00', '020-8861', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 22, 2),
(78, '00208', 'DOMINGO', 'RAMOS', '6-55-1742', '0000-00-00', '261-4536', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-4', NULL, '650.01', '3.12', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 7, 2),
(79, '00209', 'FERNANDO', 'RAMOS', '6-61-808', '0000-00-00', '201-9893', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-5', NULL, '600', '2.88', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(80, '00206', 'OVIDIO', 'RAMOS', '6-43-850', '0000-00-00', '261-1916', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-3', NULL, '650.01', '3.12', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(81, '00118', 'CRISTIAN', 'RAMOS GALLARDO', '6-55-1742', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'C-1', NULL, '625', '3', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 18, 2),
(82, '00217', 'ALFONSO FRANCISCO', 'REYES ESPINOSA', '8-828-2272', '0000-00-00', '8-828-2272', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-1', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 2),
(83, '00176', 'SILVINO', 'REYES RODRIGUEZ', '8-718-2206', '0000-00-00', '8-718-2206', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '500', '2.4', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(84, '00038', 'DAGOBERTO AMILCAR', 'RIVERA ESTURAIN', '8-524-1243', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '539.99', '2.59', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 2),
(85, '00203', 'MANUEL', 'RODRIGUEZ', '8-702-2482', '0000-00-00', '312-3614', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '550', '2.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 2),
(86, '00204', 'OMAR', 'RODRIGUEZ', '8-519-1449', '0000-00-00', '261-1968', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '550', '2.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 2),
(87, '00156', 'VICTOR JULIO', 'ROJAS ALVARADO', '8-353-182', '0000-00-00', '231-8312', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'C-2', NULL, '799.99', '3.84', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 18, 2),
(88, '00188', 'ALEXI ABDIEL', 'RUIZ ROMERO', '8-799-56', '0000-00-00', '8-799-56', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 2),
(89, '00226', 'DILAN', 'SAAVEDRA', '8-891-1114', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(90, '00189', 'NICOLAS ESTEBAN', 'SAMUDIO CHIRU', '8-889-2079', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 24, 2),
(91, '00201', 'PEDRO', 'SANCHEZ', '8-418-690', '0000-00-00', '172-3062', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '650.01', '3.12', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 6, 2),
(92, '00079', 'RAFAEL ALBERTO', 'SARMIENTO', 'E-8-77411', '0000-00-00', '292-5865', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '836', '4.01', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(93, '00240', 'LUIS ALBERTO', 'VECES MITRE', '8-949-919', '0000-00-00', '8-494-919', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-3', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 22, 2),
(94, '00149', 'EMILIANO', 'VENADO JIMENES', '4-804-1128', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-3', NULL, '500', '2.4', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 25, 2),
(95, '00012', 'DIBIS JAVIER', 'VILLALOBOS', '6-78-679', '0000-00-00', '145-8116', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-1', NULL, '799.99', '3.84', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 2),
(96, '00032', 'RICARDO ALEXIS', 'WORTHINGTON MORAN', '8-236-2345', '0000-00-00', '56-0819', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-2', NULL, '539.99', '2.59', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 7, 2),
(97, '00239', 'ERIC ABDIEL', 'ZORRILLA REYES', '8-804-788', '0000-00-00', '8-804-788', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 22, 2),
(98, '00021', 'FRANCISCA', 'ABREGO DIAZ', '9-158-563', '0000-00-00', '9-158-563', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'C-2', NULL, '600', '2.88', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(99, '00047', 'KATHYA MAGDALENA', 'ARCIA SAEZ', '8-702-1400', '0000-00-00', '8-702-1400', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'C-2', NULL, '900', '4.32', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(100, '00113', 'DANIEL', 'ARENAS FRANCO', '6-58-1771', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'C-2', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(101, '00010', 'RORY MILCIADES', 'BEITIA GUERRA', '4-218-155', '0000-00-00', '182-2372', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '389.03', '1.87', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(102, '00002', 'JULIO ENRIQUE', 'CABALLERO GUERRA', '4-139-251', '0000-00-00', '213-4770', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '440.63', '2.11', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(103, '00008', 'JULIO ENRIQUE', 'CABALLERO SALDANA', '4-745-1283', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'C-0', NULL, '650.01', '3.12', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(104, '00037', 'GUSTAVO NELSON', 'CALVO BARRIA', '6-85-991', '0000-00-00', '6-85-991', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-0', NULL, '366.97', '1.76', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(105, '00116', 'JESUS', 'CARREA SOTO', '9-709-350', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-3', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(106, '00083', 'ERICK HIPOLITO', 'CASTILLO DELGADO', '8-916-1590', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(107, '00048', 'ELVIS ANTONIO', 'CASTILLO MARTINEZ', '4-746-2175', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '389.94', '1.87', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(108, '00024', 'FELICIO', 'CRUZ PEREZ', '9-220-2275', '0000-00-00', '303-1215', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '359.99', '1.73', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(109, '00100', 'MARIA ISABEL', 'DIAZ', '3-705-731', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(110, '00052', 'FLORENTINO', 'ESPINO CANO', '7-106-210', '0000-00-00', '7-106-210', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '341.13', '1.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(111, '00114', 'AIDA ESTHER', 'FLORES REYES', '3-737-626', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(112, '00070', 'ELVIRA', 'GARCIA  CASTILLO', '2-162-255', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '341.13', '1.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(113, '00095', 'MARITZA', 'HERNANDEZ', '9-707-1958', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(114, '00050', 'ALMA ROSA', 'IBARRA ROSARIO', '3-705-2056', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '341.13', '1.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(115, '00101', 'RICARDO', 'JIMENEZ GARCIA', '4-275-164', '0000-00-00', '4-275-164', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(116, '00041', 'GUILLERMO AUGUSTO', 'JIMENEZ SAEZ', '7-106-935', '0000-00-00', '7-106-935', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '453.45', '2.18', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(117, '00012', 'CARLOS', 'MENDOZA', '4-752-212', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-0', NULL, '359.99', '1.73', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(118, '00082', 'JACINTO', 'MORALES CASTILLO', '1-724-2197', '0000-00-00', '99-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'C-3', NULL, '341.13', '1.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(119, '00115', 'ELIZABETH', 'MORAN REYES', '3-718-782', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'E-2', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(120, '00110', 'MERBIZ URIEL', 'NUNEZ GOMEZ', '3-720-813', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'C-0', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(121, '00034', 'CARLOS ENRIQUE', 'PEREZ GONZALEZ', '6-66-491', '0000-00-00', '199-5307', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '366.11', '1.76', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(122, '00023', 'DAVID', 'PEREZ JUAREZ', '3-706-861', '0000-00-00', '3-706-861', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '359.99', '1.73', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(123, '00015', 'DAMIAN', 'PEREZ NUNEZ', '2-79-774', '0000-00-00', '109-7182', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'C-0', NULL, '359.99', '1.73', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(124, '00105', 'ARCENIO', 'PINEDA CAMARENA', '3-703-978', '0000-00-00', '3-703-978', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(125, '00054', 'NOEL ANTONIO', 'RIOS MELA', '6.715-1202', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '341.13', '1.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(126, '00036', 'SAMUEL', 'RODRIGUEZ CABALLERO', '7-85-646', '0000-00-00', '7-85-646', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'C-0', NULL, '399.99', '1.92', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(127, '00004', 'HERNAN DEL CARMEN', 'SALDANA', '4-294-2066', '0000-00-00', '202-9465', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-0', NULL, '420.23', '2.02', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(128, '00040', 'ISIDRO', 'SANTANA RODRIGUEZ', '9-139-524', '0000-00-00', '262-3838', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-1', NULL, '341.13', '1.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(129, '00017', 'SONIA MARIA', 'SANTANA VALDES', '3-723-1048', '0000-00-00', '3-723-1048', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'A-2', NULL, '341.13', '1.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(130, '00093', 'ERNESTO', 'SOTO ORTEGA', '3-93-583', '0000-00-00', '3-93-583', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-3', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(131, '00111', 'YENNY AYNETH', 'VASQUEZ SOLIS', '3-732-1650', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'E-2', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(132, '00109', 'MARCO', 'VEGA ABREGO', '8-927-1460', '0000-00-00', '8-927-1460', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(133, '00076', 'MAGDA ELCIRA', 'VILLALTA VEGA', '4-271-683', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'E-3', NULL, '341.13', '1.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, NULL, 3),
(134, '00022', 'JUAN', 'AROSEMENA', '4-703-2439', '0000-00-00', '9999-99', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '347.37', '1.67', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 27, 7),
(135, '00044', 'RONNIE ABEL', 'CHAVEZ MENDOZA', '6-712-2114', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-1', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 7),
(136, '00024', 'JOSE ANTONIO', 'DE LA CRUZ', '8-527-1785', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '349.99', '1.68', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 7),
(137, '00007', 'PAULO ABEL', 'GRAJALES MORALES', '4-238-646', '0000-00-00', '4-238-646', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-3', NULL, '416.01', '2', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 36, 7),
(138, '00019', 'OFELINO', 'MARTINEZ', '4-146-1849', '0000-00-00', '285-5138', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-3', NULL, '349.45', '1.68', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 27, 7),
(139, '00002', 'ERICK ERNESTO', 'MARTINEZ RODRIGUEZ', '8-700-1477', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-1', NULL, '376.49', '1.81', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 7),
(140, '00011', 'BLAS', 'MARTINEZ SANCHEZ', '8-164-127', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-1', NULL, '370.25', '1.78', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 28, 7),
(141, '00048', 'JULIO CESAR', 'MENDOZA JIMENEZ', '9-173-417', '0000-00-00', '9-173-417', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-1', NULL, '449.99', '2.16', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 7),
(142, '00040', 'ARMANDO MAXIMINO', 'NIETO VEGA', '7-117-302', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'C-2', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 37, 7),
(143, '00023', 'NICOLAS', 'PEREZ', '6-56-1953', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '361.95', '1.74', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 7),
(144, '00018', 'JOSE ANTONIO', 'RIOS VERGARA', '7-113-860', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-5', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 33, 7),
(145, '00049', 'RONY IVAN', 'SURDO CIRES', '4-766-1165', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-1', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 11, 7),
(146, '00458', 'DIONISIO', 'ABREGO', '4-795-4289', '0000-00-00', '4-795-4289', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-5', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 31, 1),
(147, '00385', 'FRANKLIN ALBERTO', 'ACOSTA MIRANDA', '4-739-1809', '0000-00-00', '4-739-1809', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-3', NULL, '359.99', '1.73', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 31, 1),
(148, '00496', 'JULIO ERNESTO ', 'AGRAZAL VISUETI', '2-735-1809', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 43, 1),
(149, '00125', 'ENRIQUE', 'AGUILAR', '4-702-2493', '0000-00-00', '151-6970', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-1', NULL, '391.05', '1.88', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 11, 1),
(150, '00249', 'JOSE DEL CARMEN', 'AGUILAR', '8-527-1555', '0000-00-00', '036-7439', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-4', NULL, '438.89', '2.11', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(151, '00350', 'RAUL', 'AGUILAR AQUILA', '4-785-1769', '0000-00-00', '4-785-1769', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-3', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(152, '00479', 'CRESENCIO', 'AGUILAR HERNANDEZ', '2-102-1267', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-2', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 43, 1),
(153, '00434', 'ROMAN', 'AGUILAR JIRON', '4-773-343', '0000-00-00', '4-773-343', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 12, 1),
(154, '00281', 'JOSE RAMON', 'AGUILAR SANCHEZ', '8-787-1634', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '370.00', '1.77', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(155, '00353', 'ALEXANDER JAVIER', 'AGUIRRE ISAAC', '8-474-584', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-1', NULL, '625.00', '3.00', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 23, 1),
(156, '00247', 'JOSE', 'ALABARCA', '8-832-1776', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '366.09', '1.76', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 1),
(157, '00297', 'ELADIO', 'ALABARCA FLORES', '8-850-1353', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 1),
(158, '00401', 'JOSE MANUEL', 'ALABARCA FLORES', '8-886-478', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 1),
(159, '00129', 'ELADIO', 'ALABARCA R.', '8-897-2038', '0000-00-00', '241-5823', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-4', NULL, '699.99', '3.36', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 1),
(160, '00438', 'ADONIS ALBERTO', 'ANDRADES MORAN ', '8-897-2038', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 19, 1),
(161, '00405', 'HERMOGENE', 'ARAUZ DE GRACIA ', '4-116-876', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-0', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 31, 1),
(162, '00448', 'DIANA PATRICIA', 'ALBOLEDA ALVAREZ', 'E-8-107747', '0000-00-00', 'E-8-107747', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'A-0', NULL, '1120.00', '5.38', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(163, '00395', 'LEIDIS NORELIS', 'ATENCIO LARA', '4-742-1854', '0000-00-00', '4-742-1854', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'C-0', NULL, '1200.00', '5.76', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 30, 1),
(164, '00436', 'ELIAS ENRIQUE', 'ATENCIO RAMOS', '8-292-775', '0000-00-00', '8-292-775', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-3', NULL, '550.00', '2.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 23, 1),
(165, '00457', 'EVELIN ROSMERY', 'AVILA PRADO', '6-708-2389', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'E-0', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(166, '00095', 'DOMINGO', 'BARRANCO', '4-251-855', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '370.25', '1.78', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 29, 1),
(167, '00387', 'JOSE BARRERA', 'BARRERA ARAUZ', '8-524-785', '0000-00-00', '186-9245', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '550.00', '2.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 23, 1),
(168, '00432', 'JOSE ANTONIO', 'BARRERA RODRIGUEZ', '8-158-674', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'C-0', NULL, '550.00', '2.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 64, 1),
(169, '00215', 'MIGUEL', 'BARRIA', '9-716-2229', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '386.89', '1.86', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(170, '00363', 'ISMAEL', 'BARRIA BONILLA', '6-701-1230', '0000-00-00', '6-701-1230', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '341.13', '1.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(171, '00455', 'MARIA GUADALUPE', 'BARRIOS PRADO', '8-903-466', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'A-0', NULL, '500.00', '2.40', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(172, '00183', 'DELARY E.', 'BERNAT', '8-246-107', '0000-00-00', '152-1846', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-1', NULL, '1399.99', '6.73', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(173, '00469', 'JIRINA ELIZABETH', 'BOTELLO', '8-867-307', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'A-0', NULL, '600.00', '2.88', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(174, '00393', 'ISIS ELIZABETH', 'BOTELLO CABALLERO', '8-771-2471', '0000-00-00', '8-771-2471', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'A-0', NULL, '799.99', '3.84', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(175, '00123', 'TEOFILO', 'CABALLERO', '8-529-2094', '0000-00-00', '243-1416', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-5', NULL, '416.01', '2.00', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 11, 1),
(176, '00171', 'MILCIADES', 'CAMPOS DE LA CRUZ', '2-700-1437', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '650.01', '3.12', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 60, 1),
(177, '00230', 'GENARO', 'CARDENAS', '8-346-923', '0000-00-00', '333-8564', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '353.61', '1.70', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 19, 1),
(178, '00253', 'LUIS ARIEL', 'CARDENAS MORAN', '8-842-1841', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '347.37', '1.67', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 19, 1),
(179, '00337', 'MELVIN IVAN', 'CARDENAS MORAN', '8-864-2283', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '374.99', '1.80', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 19, 1),
(180, '00468', 'SOBEIDA LISBETH', 'CARDENAS MORAN', '8-888-1014', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'A-0', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 19, 1),
(181, '00483', 'RUFINO', 'CARPINTERO', '4-749-2197', '0000-00-00', '303-3473', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-5', NULL, '391.05', '1.88', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 11, 1),
(182, '00433', 'SERGIO', 'CARPINTERO', '4-807-1925', '0000-00-00', '4-807-1925', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 11, 1),
(183, '00413', 'FELICIANO', 'CARPINTERO CARPINTER', '4-810-1', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 11, 1),
(184, '00487', 'BENITO', 'CASTILLERO JIRON', '8-880-133', '0000-00-00', '8-880-133', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 11, 1),
(185, '00403', 'ANGEL ALBERTO', 'CASTILLERO ESPINOSA', '8-784-2426', '0000-00-00', '8-784-2426', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-2', NULL, '550.00', '2.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(186, '00486', 'KATHERINE DEL CARMEN', 'CASTILLERO ESPINOSA', '8-844-1781', '0000-00-00', '8-844-1781', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'E-1', NULL, '500.00', '2.40', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(187, '00380', 'CINTHIA ISSETH', 'CASTILLO BOYD', '8-810-1481', '0000-00-00', '8-810-1481', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'C-0', NULL, '699.99', '3.36', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(188, '00006', 'AGRIPINA', 'CEDENO B.', '8-453-127', '0000-00-00', '243-1766', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'E-2', NULL, '799.99', '3.84', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(189, '00067', 'CELEDONIO MANUEL', 'CEDENO CHERIGO', '2-118-777', '0000-00-00', '999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-2', NULL, '399.99', '1.92', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(190, '00058', 'SOLIE DIANNETHE', 'CEDENO QUIROZ', '8-855-835', '0000-00-00', '8-855-835', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'A-0', NULL, '650.01', '3.12', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(191, '00039', 'ARIEL ANTONIO', 'CHAVEZ MENDOZA', '6-707-758', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-1', NULL, '386.89', '1.86', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(192, '00043', 'FEDERICO', 'CHAVEZ OSORIO', '6-48-548', '0000-00-00', '34-2059', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'A-0', NULL, '372.99', '1.80', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 24, 1),
(193, '00371', 'TRINIDAD ORIEL', 'CHAVEZ SERRANO', '6-704-377', '0000-00-00', '6-704-377', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'A-2', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(194, '00120', 'ROBERTO DIMAS', 'CONTRERAS RUIZ', '8-317-842', '0000-00-00', '333-1378', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'C-3', NULL, '550.00', '2.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 60, 1),
(195, '00311', 'SEBERINO', 'CORREOSO VILLARREAL', '7-97-878', '0000-00-00', '333-3470', NULL, 1, 1, 1, 1, 0, '0000-00-00', 'E-0', NULL, '1699.99', '8.17', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 4, 1),
(196, '00065', 'ITZEL ESTHER', 'CURRA MONTENEGRO', '8-769-1993', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', 'A-0', NULL, '799.99', '3.84', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(197, '00025', 'ORMELIS', 'DE LA CRUZ', '8-718-1236', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '449.99', '2.16', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(198, '00152', 'SANTOS I.', 'DE LA CRUZ', '8-510-106', '0000-00-00', '095-8903', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '799.99', '3.84', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(199, '00410', 'JORGE DANIEL', 'DE LA CRUZ CHIRU', '2-731-274', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '361.95', '1.74', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(200, '00370', 'CYNTHIA AZUCENA', 'DE LA CRUZ TORRES', '8-826-173', '0000-00-00', '8-826-173', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '359.99', '1.73', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(201, '00464', 'EDGAR ANDRADE', 'DE LA CRUZ TORRES', '8-529-393', '0000-00-00', '8-529-393', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(202, '00254', 'PATROCINIO', 'DELGADO GOMEZ', '8-347-683', '0000-00-00', '95-3006', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '347.37', '1.67', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 19, 1),
(203, '00313', 'JOHEL ENRIQUE', 'DELGADO GOMEZ', '2-709-1348', '0000-00-00', '2-709-1348', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(204, '00481', 'JOSE ELISEO', 'DIAZ JUSTINIANI', '2-157-458', '0000-00-00', '99-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '349.99', '1.68', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 27, 1),
(205, '00280', 'JACQUELINE DEL CARME', 'DIAZ QUINTERO', '8-721-1488', '0000-00-00', '8-721-1488', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '370.00', '1.77', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(206, '00462', 'JOSHUA RITO', 'DIAZ RODRIGUEZ', '8-841-205', '0000-00-00', '8-841-205', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '500.00', '2.40', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(207, '00014', 'RIGOBERTO RAMIRO', 'DOMINGUEZ HIGUERA', '6-56-2382', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '413.00', '1.99', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(208, '00055', 'JORGE DANIEL', 'ESPINOSA GOMEZ', '4-193-990', '0000-00-00', '036-6232', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '424.99', '2.04', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 33, 1),
(209, '00036', 'MELANIA ROQUELINA', 'FLORES PINTO', '6-67-414', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '459.69', '2.21', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(210, '00491', 'CARLOS LUIS', 'FRANCO', '9-738-944', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(211, '00099', 'FERMIN', 'FRANCO ARAUZ', '4-103-2655', '0000-00-00', '37-6395', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '374.99', '1.80', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 31, 1),
(212, '00447', 'ADAN', 'FRIAS GONZALEZ', '8-369-247', '0000-00-00', '', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '900.00', '4.32', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(213, '00418', 'IRENE', 'GAITAN', '6-718-412', '0000-00-00', '9999-999', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(214, '00492', 'ARQUIMEDES', 'GARCIA', '7-708-2087', '0000-00-00', '7-708-2087', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(215, '00240', 'ROLANDO OSCAR', 'GARCIA DE GRACIA ', '8-705-1577', '0000-00-00', '8-705-1577', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '600.00', '2.88', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 23, 1);
INSERT INTO `empleados` (`id_empleado`, `numero_empleado`, `nombre`, `apellido`, `cedula`, `fecha_nacimiento`, `seguro_social`, `tipo_sangre`, `id_estado_empleado`, `id_genero`, `id_estado_civil`, `id_nacionalidad`, `sindicato`, `fecha_venc_carnet`, `clave_renta`, `forma_pago`, `salario`, `rata_x_hora`, `horas_x_periodo`, `fecha_ingreso`, `fecha_prox_vacaciones`, `fecha_venc_contrato`, `pago_efectivo`, `frecuencia_pago`, `isr_gasto`, `fecha_terminacion`, `id_cargo`, `id_seccion`, `id_empresa`) VALUES
(216, '00493', 'EUGENIO', 'GARCIA SANTO', '1-745-450', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(217, '00147', 'EVENCIO HIDALGO', 'GIL', '8-211-1048', '0000-00-00', '069-4100', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '388.97', '1.87', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 10, 1),
(218, '00185', 'EDGAR ABRAHAM', 'GOMEZ ARANDA', '8-211-1048', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '600.00', '2.88', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 60, 1),
(219, '00100', 'JACINTO', 'GONZALEZ', '8-267-687', '0000-00-00', '278-8957', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '341.13', '1.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 22, 1),
(220, '00381', 'CHRISTOPHER ADRIAN', 'GONZALEZ ALMANZA', '8-866-216', '0000-00-00', '8-866-216', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '600.00', '2.88', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(221, '00318', 'JUAN', 'GONZALEZ CAMANO', '9-708-824', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 1),
(222, '00490', 'ALFARO', 'GRACIA', '2-724-233', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(223, '00315', 'LUIS ALBERTO', 'GUEVARA BLANCO', '8-748-351', '0000-00-00', '8-748-351', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '999.99', '4.80', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(224, '00235', 'HENRY LEONEL', 'HERRERA', '8-764-1692', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(225, '00373', 'DIONICIO', 'HIDALGO CORONADO', '8-254-543', '0000-00-00', '8-254-543', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '359.99', '1.73', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(226, '00245', 'MAYCA GIMA', 'HIDALGO PEREZ', '8-502-645', '0000-00-00', '69-5797', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '423.65', '2.08', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(227, '00309', 'NESTOR JOSE', 'JAEN ATENCIO', '8-892-1471', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '850.00', '4.08', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(228, '00002', 'KATYA', 'JAEN DE LA CRUZ', '8-474-319', '0000-00-00', '999-9999', '', 1, 2, 1, 1, 0, '0000-00-00', '', '', '999.99', '4.80', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, '', 0, '0000-00-00', 3, 1, 1),
(229, '00442', 'JOAQUIN', 'JAEN PIMENTEL', '7-75-806', '0000-00-00', '41-5952', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '799.99', '3.84', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 23, 1),
(230, '00400', 'ADAN', 'JULIZ BARRANCO', '8-819-1148', '0000-00-00', '8-819-1148', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 1),
(231, '00296', 'ALBERTO', 'JULIZ BARRANCO', '8-892-1471', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '341.13', '1.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 1),
(232, '00428', 'ARCADIO', 'JULIZ BARRANCO', '8-775-2321', '0000-00-00', '9999-99', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 1),
(233, '00397', 'ROLANDO  ', 'LOPEZ SANCHEZ', '8-256-659', '0000-00-00', '103-5135', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '999.99', '4.80', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(234, '00383', 'BEXSAIDA ARACELIS', 'LORENZO RODRIGUEZ', '8-755-812', '0000-00-00', '8-755-812', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '3.84', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(235, '00216', 'ALEX DOMINGO', 'LORENZO SANCHEZ', '8-774-2133', '0000-00-00', '8-774-2133', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '850.00', '4.08', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(236, '00424', 'ABELARDO', 'MARTINEZ GONZALEZ', '4-217-479', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 31, 1),
(237, '00476', 'JUAN CARLOS', 'MARTINEZ SANCHEZ', '2-711-375', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 43, 1),
(238, '00449', 'ESTEBAN', 'MEDINA', '2-101-514', '0000-00-00', '999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '361.95', '1.74', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(239, '00471', 'ROLANDO ARTURO', 'MENDOZA TAPIA', '8-237-1824', '0000-00-00', '315-0095', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '1500.00', '7.21', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 64, 1),
(240, '00497', 'GERMAN', 'MENESES GONZALES', '2-761.1364', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 43, 1),
(241, '00498', 'DEMETRIO', 'MENESES GONZALEZ', '2-755-881', '0000-00-00', '2-755-881', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(242, '00225', 'ABDIAS ABDIEL', 'MIRANDA JIMENEZ', '4-723-1673', '0000-00-00', '4-723-1673', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '343.21', '1.65', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 64, 1),
(243, '00110', 'GREGORIO', 'MIRANDA MACHO', '4-217-766', '0000-00-00', '345-0788', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '347.37', '1.67', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 43, 1),
(244, '00454', 'DEMETRIO', 'MIRANDA MIRANDA', '4-182-280', '0000-00-00', '255-4983', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 43, 1),
(245, '00310', 'PEDRO PAULO', 'MOJICA HIDALGO', '8-848-677', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '391.05', '1.88', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 33, 1),
(246, '00356', 'ARCENIO', 'MONTANA MONTEZUMA', '4-746-1224', '0000-00-00', '4-746-1224', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 31, 1),
(247, '00465', 'SANTIAGO', 'MONTEZUMA', '1-753-1851', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(248, '00027', 'EUCLIDES', 'MORALES', '2-710-311', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '391.05', '1.88', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 19, 1),
(249, '00160', 'JORGE ARMANDO', 'MORALES', '8-745-2332', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '600.00', '2.88', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 22, 1),
(250, '00290', 'PLACIDO ENRIQUE', 'MORALES RAMOS', '8-733-42', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '341.13', '1.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 22, 1),
(251, '00169', 'ANDRES', 'MORAN', '8-331-629', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '401.45', '1.93', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 19, 1),
(252, '00437', 'ANTONIO ISAIAS', 'MORAN', '8-852-1721', '0000-00-00', '8-852-1721', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '600.00', '2.88', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 19, 1),
(253, '00440', 'JORGE ARMANDO', 'MORAN', '8-852-1722', '0000-00-00', '8-852-1722', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '390.01', '1.87', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 20, 1),
(254, '00470', 'VERONICA', 'MORAN MORAN', '8-906-16', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 19, 1),
(255, '00399', 'CINTHIA ANAYS', 'MORENO FLORES', '8-702-2472', '0000-00-00', '435-1181', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '699.99', '3.36', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(256, '00459', 'KIRIA ANETH', 'MURILLO SANCHEZ', '8-799-267', '0000-00-00', '8-799-267', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '500.00', '2.40', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(257, '00348', 'JOSE GILBERTO', 'NUNEZ BELLIDO', '8-741-1650', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '341.13', '1.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 22, 1),
(258, '00357', 'DIVIEL', 'ORTEGA', '9-728-2134', '0000-00-00', '9-728-2134', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '359.99', '1.73', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(259, '00441', 'EDMUNDO', 'ORTEGA', '8-719-434', '0000-00-00', '48-9777', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '1200.00', '5.76', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(260, '00409', 'SILVERIO ANTONIO', 'ORTEGA DE LA CRUZ', '8-719-434', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(261, '00097', 'JOSE ISIDRO', 'OVALLE BENITEZ', '8-524-1738', '0000-00-00', '8-524-1738', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '426.55', '2.05', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 28, 1),
(262, '00477', 'RAMON', 'PADILLA SANCHEZ', '3-734-794', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 43, 1),
(263, '00327', 'HERIBERTO', 'PEREZ', '8-800-534', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '850.00', '4.08', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 43, 1),
(264, '00217', 'YANIS JOEL', 'PEREZ FIGUEROA', '8-517-1340', '0000-00-00', '199-6216', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '600.00', '2.88', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 23, 1),
(265, '00466', 'JOSE', 'PIMENTEL', '6-719-1434', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(266, '00452', 'NORIELA MARIA', 'PIMENTEL BONILLA', '6-707-1572', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(267, '00302', 'ROSA ENEIDA', 'PIMENTEL FLORES', '6-702-1501', '0000-00-00', '6-702-1501', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '370.00', '1.77', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(268, '00473', 'MARCOS ARIEL', 'PIMENTEL PEREZ', '6-718-1608', '0000-00-00', '6-718-1608', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(269, '00300', 'ADRIANO ALBERTO', 'PINZON MORAN', '8-736-438', '0000-00-00', '8-736-438', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '600.00', '2.88', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 23, 1),
(270, '00453', 'BARTOLO', 'QUINTERO FLORES', '4-800-1817', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 29, 1),
(271, '00283', 'SEVERINA', 'QUINTERO HIGUERA', '6-56-1420', '0000-00-00', '9999-999', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '341.13', '1.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(272, '00091', 'ERIC ALBERTO', 'RAMOS PINZON', '2-703-922', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '411.87', '1.98', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(273, '00047', 'LIZBETH LILIANA', 'REINA SOSA', '8-774-1905', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '1200.00', '5.76', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(274, '00366', 'FABIO', 'RIOS', '8-521-496', '0000-00-00', '291-2015', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '900.00', '4.32', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(275, '00474', 'EDGARDO DAVID', 'RIVAS CASTRO', '2-736-205', '0000-00-00', '999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 43, 1),
(276, '00485', 'JAHIR', 'RODRIGUEZ', '2-726-563', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 46, 1),
(277, '00191', 'REINALDO', 'RODRIGUEZ', '8-164-1105', '0000-00-00', '171-1391', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '699.99', '3.36', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 60, 1),
(278, '00037', 'BELLS ELIZABETH', 'RODRIGUEZ GARCIA', '8-713-1213', '0000-00-00', '8-713-1213', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '1200.00', '5.76', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(279, '00161', 'NICANOR', 'RODRIGUEZ MAGALLON', '2-146-964', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '388.97', '1.87', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 10, 1),
(280, '00319', 'JOSE MIGUEL', 'RODRIGUEZ OJO', '2-726-1006', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 1),
(281, '00109', 'JUAN CARLOS', 'RODRIGUEZ OJO', '2-730-2182', '0000-00-00', '2-730-2182', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 15, 1),
(282, '00165', 'FRANCISCO', 'RODRIGUEZ R.', '9-219-1663', '0000-00-00', '261-4520', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '699.99', '3.36', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 11, 1),
(283, '00096', 'HERMEL', 'ROSAS', '4-182-186', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '550.00', '2.64', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 29, 1),
(284, '00198', 'ROBERTO JACOB', 'RUEDA ORTEDA', '4-239-322', '0000-00-00', '4-239-322', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '999.99', '4.80', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 19, 1),
(285, '00295', 'SAADIA MARITZA', 'RUIZ BATISTA', '8-767-2480', '0000-00-00', '8-767-2480', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '749.99', '3.60', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(286, '00332', 'JONATAN ABIMAEL', 'RUIZ FUENTES', '8-762-712', '0000-00-00', '8-762-712', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '799.99', '3.84', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(287, '00503', 'ALEJANDRO ALEXIS', 'SAAVEDRA MENDOZA', '6-706-2001', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '500.00', '2.40', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(288, '00430', 'AMILCAR', 'SALAS GIRON', '4-732-208', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 43, 1),
(289, '00431', 'ANIBAL APARICIO', 'SALAS GIRON', '4-760-1312', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 43, 1),
(290, '00500', 'JOSE LUIS', 'SAMANIEGO GALLARDO', '8-756-2331', '0000-00-00', '8-756-2331', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '488.81', '2.35', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 4, 1),
(291, '00421', 'ESTENIA', 'SANCHEZ', '6-712-891', '0000-00-00', '9999-999', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(292, '00425', 'PEDRO', 'SANCHEZ ERYES', '8-708-1295', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 28, 1),
(293, '00132', 'IRVING', 'SANTAMARIA', '4-118-2618', '0000-00-00', '202-5006', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '374.99', '1.80', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 31, 1),
(294, '00484', 'NOEL', 'SANTO', '9-743-1754', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(295, '00137', 'SIMON', 'SANTOS PALACIOS', '4-271-937', '0000-00-00', '292-1901', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '399.99', '1.92', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 31, 1),
(296, '00443', 'DIOMEDES', 'SIBALA', '1-736-1073', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(297, '00444', 'ISMAEL', 'SIBALA GARCIA', '1-749-1591', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(298, '00388', 'NORIEL ', 'SIBALA GARCIA', '1-736-1072', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '361.95', '1.74', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(299, '00061', 'MARCELINO', 'SOTO MOJICA', '9-713-512', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '357.77', '1.72', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 40, 1),
(300, '00237', 'NICOLAS JAVIER', 'STANZIOLA DIAZ', '2-107-795', '0000-00-00', '2-107-795', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '370.25', '1.78', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 43, 1),
(301, '00494', 'PEDRO EMILIO', 'TAPIERO PITTI', '4-719-1158', '0000-00-00', '4-719-1158', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '1200.00', '5.76', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 30, 1),
(302, '00289', 'RONY CLEMENT', 'TENORIO CONCEPCION', '9-736-1330', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(303, '00372', 'MARLENE YARICEL', 'URENA MIRANDA', '8-851-667', '0000-00-00', '9999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '600.00', '2.88', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1),
(304, '00151', 'BORIS', 'VALDES', '8-316-247', '0000-00-00', '205-0341', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '420.17', '2.02', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(305, '00166', 'JESUS', 'VALDES', '9-84-1442', '0000-00-00', '145-4551', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '401.45', '1.93', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 19, 1),
(306, '00495', 'LUIS CARLOS', 'VALDES BUSTAMANTE', '3-737-778', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(307, '00368', 'ERNESTO GIL', 'VALDES ROMERO', '8-239-1097', '0000-00-00', '145-4339', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '532.63', '2.56', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 4, 1),
(308, '00153', 'NESTOR ISAAC', 'VALDES URENA', '8-244-966', '0000-00-00', '115-9100', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '449.29', '2.16', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 10, 1),
(309, '00203', 'YONI ALBERTO', 'VARGAS SANCHEZ', '8-518-1936', '0000-00-00', '205-3689', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '380.00', '1.82', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(310, '00040', 'ELIAS SAMUEL', 'VEGA MONTENEGRO', '6-85-116', '0000-00-00', '999-9999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 17, 1),
(311, '00450', 'ADELINO', 'VELASQUES', '2-737-971', '0000-00-00', '999-999', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '336.97', '1.62', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 9, 1),
(312, '00112', 'GENARO', 'VILLAREAL GOMEZ', '4-170-800', '0000-00-00', '175-2568', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '359.99', '1.73', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 31, 1),
(313, '00251', 'CARLOS ALBERTO', 'VILLAREAL PINTO', '8-714-298', '0000-00-00', '8-714-298', NULL, 1, 1, 1, 1, 0, '0000-00-00', '', NULL, '799.99', '3.84', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 64, 1),
(314, '00502', 'DAYSI', 'ZAMBRANO BARRIA', '8-877-633', '0000-00-00', '999-9999', NULL, 1, 2, 1, 1, 0, '0000-00-00', '', NULL, '500.00', '2.40', '208', '0000-00-00', '0000-00-00', '0000-00-00', 1, NULL, 0, '0000-00-00', NULL, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresas`
--

CREATE TABLE IF NOT EXISTS `empresas` (
  `id_empresa` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_empresa` varchar(100) DEFAULT NULL,
  `representante_legal` varchar(100) DEFAULT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `apartado_postal` varchar(100) DEFAULT NULL,
  `comentario` varchar(100) DEFAULT NULL,
  `telefono_1` varchar(100) DEFAULT NULL,
  `telefono_2` varchar(100) DEFAULT NULL,
  `codigo_actividad` int(1) DEFAULT NULL,
  `mostrar` int(11) NOT NULL DEFAULT '1',
  `anno_proceso` varchar(100) DEFAULT NULL,
  `mes_proceso` varchar(100) DEFAULT NULL,
  `clave_acceso` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_empresa`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Volcado de datos para la tabla `empresas`
--

INSERT INTO `empresas` (`id_empresa`, `nombre_empresa`, `representante_legal`, `direccion`, `apartado_postal`, `comentario`, `telefono_1`, `telefono_2`, `codigo_actividad`, `mostrar`, `anno_proceso`, `mes_proceso`, `clave_acceso`) VALUES
(1, 'CAISA', NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL),
(2, 'PICSA', NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL),
(3, 'VELKARI', NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL),
(4, 'AGUACATE', NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL),
(5, 'SMARTS PORK', NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL),
(6, 'IRBRO', NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL),
(7, 'RIAJO', ' ', '', '', '', '', NULL, 1, 1, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estados_civiles`
--

CREATE TABLE IF NOT EXISTS `estados_civiles` (
  `id_estado_civil` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estado_civil` varchar(100) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_estado_civil`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Volcado de datos para la tabla `estados_civiles`
--

INSERT INTO `estados_civiles` (`id_estado_civil`, `nombre_estado_civil`, `fecha_creacion`, `id_usuario`) VALUES
(1, 'SOLTERO', '2015-03-27 02:03:11', 1),
(2, 'CASADO', '2015-03-27 02:03:12', 1),
(3, 'UNIDO', '2015-03-27 02:03:12', 1),
(4, 'DIVORCIADO', '2015-03-27 02:03:12', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estados_empleados`
--

CREATE TABLE IF NOT EXISTS `estados_empleados` (
  `id_estado_empleado` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estado_empleado` varchar(100) DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_estado_empleado`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Volcado de datos para la tabla `estados_empleados`
--

INSERT INTO `estados_empleados` (`id_estado_empleado`, `nombre_estado_empleado`, `descripcion`, `fecha_creacion`, `id_usuario`) VALUES
(1, 'ACTIVO', NULL, '2015-01-01 00:00:00', 1),
(2, 'CESADO', NULL, '2015-01-01 00:00:00', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estados_usuarios`
--

CREATE TABLE IF NOT EXISTS `estados_usuarios` (
  `id_estado_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estado_usuario` varchar(100) DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_estado_usuario`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Volcado de datos para la tabla `estados_usuarios`
--

INSERT INTO `estados_usuarios` (`id_estado_usuario`, `nombre_estado_usuario`, `descripcion`, `fecha_creacion`, `id_usuario`) VALUES
(1, 'ACTIVO', NULL, '2015-01-01 00:00:00', 1),
(2, 'INACTIVO', NULL, '2015-01-01 00:00:00', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `generos`
--

CREATE TABLE IF NOT EXISTS `generos` (
  `id_genero` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_genero` varchar(100) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_genero`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Volcado de datos para la tabla `generos`
--

INSERT INTO `generos` (`id_genero`, `nombre_genero`, `fecha_creacion`, `id_usuario`) VALUES
(1, 'MASCULINO', '2015-03-27 02:03:47', 1),
(2, 'FEMENINO', '2015-03-27 02:03:47', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `impuestos_legales`
--

CREATE TABLE IF NOT EXISTS `impuestos_legales` (
  `id_impuesto_legal` int(11) NOT NULL AUTO_INCREMENT,
  `segsoc` varchar(100) DEFAULT NULL,
  `segedu` varchar(100) DEFAULT NULL,
  `isr` varchar(100) DEFAULT NULL,
  `porcentaje_segsoc` varchar(100) DEFAULT NULL,
  `porcentaje_segedu` varchar(100) DEFAULT NULL,
  `porcentaje_isr` varchar(100) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL,
  `fecha_creacion` date DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_impuesto_legal`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Volcado de datos para la tabla `impuestos_legales`
--

INSERT INTO `impuestos_legales` (`id_impuesto_legal`, `segsoc`, `segedu`, `isr`, `porcentaje_segsoc`, `porcentaje_segedu`, `porcentaje_isr`, `estado`, `fecha_creacion`, `id_usuario`) VALUES
(1, '0.0975', '0.0125', '0.15', '9.75%', '1.25%', '15%', 1, '2015-01-01', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `impuestos_legales_empleados`
--

CREATE TABLE IF NOT EXISTS `impuestos_legales_empleados` (
  `id_impuesto_legal_empleado` int(11) NOT NULL AUTO_INCREMENT,
  `id_empleado` int(11) DEFAULT NULL,
  `numero_empleado` varchar(100) DEFAULT NULL,
  `monto_ss` varchar(100) DEFAULT NULL,
  `monto_se` varchar(100) DEFAULT NULL,
  `monto_isr` varchar(100) DEFAULT NULL,
  `id_periodo` int(11) DEFAULT NULL,
  `id_impuesto_legal` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_impuesto_legal_empleado`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Volcado de datos para la tabla `impuestos_legales_empleados`
--

INSERT INTO `impuestos_legales_empleados` (`id_impuesto_legal_empleado`, `id_empleado`, `numero_empleado`, `monto_ss`, `monto_se`, `monto_isr`, `id_periodo`, `id_impuesto_legal`) VALUES
(1, 13, '00004', '20.22', '2.59', '0.00', 3, 1),
(2, 16, '00007', '16.43', '2.11', '0.00', 3, 1),
(3, 17, '00006', '16.43', '2.11', '0.00', 3, 1),
(4, 18, '00002', '18.96', '2.43', '0.00', 3, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jornadas`
--

CREATE TABLE IF NOT EXISTS `jornadas` (
  `id_jornada` int(11) NOT NULL AUTO_INCREMENT,
  `codigo_jornada` varchar(100) DEFAULT NULL,
  `id_turno` int(11) DEFAULT NULL,
  `turno` varchar(100) DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `hora_inicia` varchar(100) DEFAULT NULL,
  `hora_termina` varchar(100) DEFAULT NULL,
  `total_horas` varchar(100) DEFAULT NULL,
  `paga` varchar(100) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_jornada`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

--
-- Volcado de datos para la tabla `jornadas`
--

INSERT INTO `jornadas` (`id_jornada`, `codigo_jornada`, `id_turno`, `turno`, `descripcion`, `hora_inicia`, `hora_termina`, `total_horas`, `paga`, `fecha_creacion`, `id_usuario`) VALUES
(1, '', 0, '', '', '00:00', '00:00', '0.00', '0.00', '2015-03-27 06:44:09', 1),
(2, '01', 1, 'DIURNO', '07:00 AM - 04:00 PM', '07:00 AM', '04:00 PM', '9.00', '8.50', '2015-03-27 06:44:09', 1),
(3, '02', 1, 'DIURNO', '07:00 AM - 12:30 PM', '07:00 AM', '12:30 PM', '5.50', '5.50', '2015-03-27 06:44:09', 1),
(4, '03', 1, 'DIURNO', '09:00 AM - 06:00 PM', '09:00 AM', '06:00 PM', '9.00', '8.50', '2015-03-27 06:44:09', 1),
(5, '04', 1, 'DIURNO', '08:00 AM - 05:00 PM', '08:00 AM', '05:00 PM', '9.00', '8.50', '2015-03-27 06:44:09', 1),
(6, '05', 3, 'NOCTURNO', '06:00 PM - 06:00 AM', '06:00 PM', '06:00 AM', '12.00', '8.00', '2015-03-27 06:44:09', 1),
(7, '06', 2, 'MIXTO', '04:30 PM - 12:00 AM', '04:30 PM', '12:00 AM', '7.50', '8.50', '2015-03-27 06:44:09', 1),
(8, '07', 2, 'MIXTO', '04:00 AM - 11:30 AM', '04:00 AM', '11:30 AM', '7.50', '8.50', '2015-03-27 06:44:09', 1),
(9, '08', 2, 'MIXTO', '03:00 AM - 10:30 AM', '03:00 AM', '10:30 AM', '7.50', '8.50', '2015-03-27 06:44:09', 1),
(10, '09', 1, 'DIURNO', '06:00 AM - 06:00 PM', '06:00 AM', '06:00 PM', '12.00', '8.00', '2015-03-27 06:44:09', 1),
(11, '10', 1, 'DIURNO', '07:00 AM - 04:00 PM', '07:00 AM', '04:00 PM', '8.00', '8.00', '2015-04-11 21:21:52', 0),
(12, '11', 1, 'DIURNO', '6:30 AM - 3:30 PM', '6:30 AM', '3:30 PM', '9.00', '8.50', '2015-03-27 16:20:43', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jornadas_empleados`
--

CREATE TABLE IF NOT EXISTS `jornadas_empleados` (
  `id_jornada_empleado` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_empleado` int(11) DEFAULT NULL,
  `numero_empleado` varchar(100) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `dia` varchar(100) DEFAULT NULL,
  `laboro` int(11) DEFAULT NULL,
  `ausencia` varchar(100) DEFAULT NULL,
  `tipo` varchar(100) DEFAULT NULL,
  `codigo` varchar(100) DEFAULT NULL,
  `codigo_jornada` varchar(100) DEFAULT NULL,
  `com` varchar(100) DEFAULT NULL,
  `hora_entra` varchar(100) DEFAULT NULL,
  `hora_sale` varchar(100) DEFAULT NULL,
  `horas_regulares` varchar(100) DEFAULT NULL,
  `horas_extras` varchar(100) DEFAULT NULL,
  `id_periodo` int(11) DEFAULT NULL,
  `anno_fiscal` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_jornada_empleado`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=141 ;

--
-- Volcado de datos para la tabla `jornadas_empleados`
--

INSERT INTO `jornadas_empleados` (`id_jornada_empleado`, `id_empleado`, `numero_empleado`, `fecha`, `dia`, `laboro`, `ausencia`, `tipo`, `codigo`, `codigo_jornada`, `com`, `hora_entra`, `hora_sale`, `horas_regulares`, `horas_extras`, `id_periodo`, `anno_fiscal`) VALUES
(1, 6, '00002', '2015-01-11', 'Sunday', 0, 'L', 'D', 'N', '', '', '00:00', '00:00', '0.00', '0.00', 3, '2014'),
(2, 6, '00002', '2015-01-12', 'Monday', 0, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(3, 6, '00002', '2015-01-13', 'Tuesday', 0, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(4, 6, '00002', '2015-01-14', 'Wednesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(5, 6, '00002', '2015-01-15', 'Thursday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(6, 6, '00002', '2015-01-16', 'Friday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(7, 6, '00002', '2015-01-17', 'Saturday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(8, 6, '00002', '2015-01-18', 'Sunday', 0, 'L', 'D', 'N', '', '', '00:00', '00:00', '0.00', '0.00', 3, '2014'),
(9, 6, '00002', '2015-01-19', 'Monday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(10, 6, '00002', '2015-01-20', 'Tuesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(11, 6, '00002', '2015-01-21', 'Wednesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(12, 6, '00002', '2015-01-22', 'Thursday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(13, 6, '00002', '2015-01-23', 'Friday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(14, 6, '00002', '2015-01-24', 'Saturday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(15, 6, '00002', '2015-01-25', 'Sunday', 1, '', 'D', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(16, 5, '00019', '2015-01-11', 'Sunday', 0, 'L', 'D', 'N', '', '', '00:00', '00:00', '0.00', '0.00', 3, '2014'),
(17, 5, '00019', '2015-01-12', 'Monday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(18, 5, '00019', '2015-01-13', 'Tuesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(19, 5, '00019', '2015-01-14', 'Wednesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(20, 5, '00019', '2015-01-15', 'Thursday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(21, 5, '00019', '2015-01-16', 'Friday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(22, 5, '00019', '2015-01-17', 'Saturday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(23, 5, '00019', '2015-01-18', 'Sunday', 0, 'L', 'D', 'N', '', '', '00:00', '00:00', '0.00', '0.00', 3, '2014'),
(24, 5, '00019', '2015-01-19', 'Monday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(25, 5, '00019', '2015-01-20', 'Tuesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(26, 5, '00019', '2015-01-21', 'Wednesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(27, 5, '00019', '2015-01-22', 'Thursday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(28, 5, '00019', '2015-01-23', 'Friday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(29, 5, '00019', '2015-01-24', 'Saturday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(30, 5, '00019', '2015-01-25', 'Sunday', 1, '', 'D', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(31, 7, '00028', '2015-01-11', 'Sunday', 0, 'L', 'D', 'N', '', '', '00:00', '00:00', '0.00', '0.00', 3, '2014'),
(32, 7, '00028', '2015-01-12', 'Monday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(33, 7, '00028', '2015-01-13', 'Tuesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(34, 7, '00028', '2015-01-14', 'Wednesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(35, 7, '00028', '2015-01-15', 'Thursday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(36, 7, '00028', '2015-01-16', 'Friday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(37, 7, '00028', '2015-01-17', 'Saturday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(38, 7, '00028', '2015-01-18', 'Sunday', 0, 'L', 'D', 'N', '', '', '00:00', '00:00', '0.00', '0.00', 3, '2014'),
(39, 7, '00028', '2015-01-19', 'Monday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(40, 7, '00028', '2015-01-20', 'Tuesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(41, 7, '00028', '2015-01-21', 'Wednesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(42, 7, '00028', '2015-01-22', 'Thursday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(43, 7, '00028', '2015-01-23', 'Friday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(44, 7, '00028', '2015-01-24', 'Saturday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(45, 7, '00028', '2015-01-25', 'Sunday', 1, '', 'D', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(46, 10, '00030', '2015-01-11', 'Sunday', 0, 'L', 'D', 'N', '', '', '00:00', '00:00', '0.00', '0.00', 3, '2014'),
(47, 10, '00030', '2015-01-12', 'Monday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(48, 10, '00030', '2015-01-13', 'Tuesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(49, 10, '00030', '2015-01-14', 'Wednesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(50, 10, '00030', '2015-01-15', 'Thursday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(51, 10, '00030', '2015-01-16', 'Friday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(52, 10, '00030', '2015-01-17', 'Saturday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(53, 10, '00030', '2015-01-18', 'Sunday', 0, 'L', 'D', 'N', '', '', '00:00', '00:00', '0.00', '0.00', 3, '2014'),
(54, 10, '00030', '2015-01-19', 'Monday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(55, 10, '00030', '2015-01-20', 'Tuesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(56, 10, '00030', '2015-01-21', 'Wednesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(57, 10, '00030', '2015-01-22', 'Thursday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(58, 10, '00030', '2015-01-23', 'Friday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(59, 10, '00030', '2015-01-24', 'Saturday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(60, 10, '00030', '2015-01-25', 'Sunday', 1, '', 'D', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(61, 9, '00032', '2015-01-11', 'Sunday', 0, 'L', 'D', 'N', '', '', '00:00', '00:00', '0.00', '0.00', 3, '2014'),
(62, 9, '00032', '2015-01-12', 'Monday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(63, 9, '00032', '2015-01-13', 'Tuesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(64, 9, '00032', '2015-01-14', 'Wednesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(65, 9, '00032', '2015-01-15', 'Thursday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(66, 9, '00032', '2015-01-16', 'Friday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(67, 9, '00032', '2015-01-17', 'Saturday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(68, 9, '00032', '2015-01-18', 'Sunday', 0, 'L', 'D', 'N', '', '', '00:00', '00:00', '0.00', '0.00', 3, '2014'),
(69, 9, '00032', '2015-01-19', 'Monday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(70, 9, '00032', '2015-01-20', 'Tuesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(71, 9, '00032', '2015-01-21', 'Wednesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(72, 9, '00032', '2015-01-22', 'Thursday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(73, 9, '00032', '2015-01-23', 'Friday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(74, 9, '00032', '2015-01-24', 'Saturday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(75, 9, '00032', '2015-01-25', 'Sunday', 1, '', 'D', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(76, 11, '00035', '2015-01-11', 'Sunday', 0, 'L', 'D', 'N', '', '', '00:00', '00:00', '0.00', '0.00', 3, '2014'),
(77, 11, '00035', '2015-01-12', 'Monday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(78, 11, '00035', '2015-01-13', 'Tuesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(79, 11, '00035', '2015-01-14', 'Wednesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(80, 11, '00035', '2015-01-15', 'Thursday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(81, 11, '00035', '2015-01-16', 'Friday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(82, 11, '00035', '2015-01-17', 'Saturday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(83, 11, '00035', '2015-01-18', 'Sunday', 0, 'L', 'D', 'N', '', '', '00:00', '00:00', '0.00', '0.00', 3, '2014'),
(84, 11, '00035', '2015-01-19', 'Monday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(85, 11, '00035', '2015-01-20', 'Tuesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(86, 11, '00035', '2015-01-21', 'Wednesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(87, 11, '00035', '2015-01-22', 'Thursday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(88, 11, '00035', '2015-01-23', 'Friday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(89, 11, '00035', '2015-01-24', 'Saturday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(90, 11, '00035', '2015-01-25', 'Sunday', 1, '', 'D', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(91, 4, '00038', '2015-01-11', 'Sunday', 0, 'L', 'D', 'N', '', '', '00:00', '00:00', '0.00', '0.00', 3, '2014'),
(92, 4, '00038', '2015-01-12', 'Monday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(93, 4, '00038', '2015-01-13', 'Tuesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(94, 4, '00038', '2015-01-14', 'Wednesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(95, 4, '00038', '2015-01-15', 'Thursday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(96, 4, '00038', '2015-01-16', 'Friday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(97, 4, '00038', '2015-01-17', 'Saturday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(98, 4, '00038', '2015-01-18', 'Sunday', 0, 'L', 'D', 'N', '', '', '00:00', '00:00', '0.00', '0.00', 3, '2014'),
(99, 4, '00038', '2015-01-19', 'Monday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(100, 4, '00038', '2015-01-20', 'Tuesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(101, 4, '00038', '2015-01-21', 'Wednesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(102, 4, '00038', '2015-01-22', 'Thursday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(103, 4, '00038', '2015-01-23', 'Friday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(104, 4, '00038', '2015-01-24', 'Saturday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(105, 4, '00038', '2015-01-25', 'Sunday', 1, '', 'D', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(106, 8, '00039', '2015-01-11', 'Sunday', 0, 'L', 'D', 'N', '', '', '00:00', '00:00', '0.00', '0.00', 3, '2014'),
(107, 8, '00039', '2015-01-12', 'Monday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(108, 8, '00039', '2015-01-13', 'Tuesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(109, 8, '00039', '2015-01-14', 'Wednesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(110, 8, '00039', '2015-01-15', 'Thursday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(111, 8, '00039', '2015-01-16', 'Friday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(112, 8, '00039', '2015-01-17', 'Saturday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(113, 8, '00039', '2015-01-18', 'Sunday', 0, 'L', 'D', 'N', '', '', '00:00', '00:00', '0.00', '0.00', 3, '2014'),
(114, 8, '00039', '2015-01-19', 'Monday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(115, 8, '00039', '2015-01-20', 'Tuesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(116, 8, '00039', '2015-01-21', 'Wednesday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(117, 8, '00039', '2015-01-22', 'Thursday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(118, 8, '00039', '2015-01-23', 'Friday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(119, 8, '00039', '2015-01-24', 'Saturday', 1, '', 'R', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(120, 8, '00039', '2015-01-25', 'Sunday', 1, '', 'D', 'N', '10', '', '07:00 AM', '04:00 PM', '8.00', '0.00', 3, '2014'),
(121, 139, '00002', '2015-06-02', 'Tuesday', 1, '', 'R', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(122, 137, '00007', '2015-06-02', 'Tuesday', 1, '', 'R', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(123, 18, '00002', '2015-06-02', 'Tuesday', 1, '', 'R', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(124, 16, '00007', '2015-06-02', 'Tuesday', 1, '', 'R', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(125, 17, '00006', '2014-01-26', 'Sunday', 1, '', 'D', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(126, 17, '00006', '2014-01-27', 'Monday', 1, '', 'R', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(127, 17, '00006', '2014-01-28', 'Tuesday', 1, '', 'R', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(128, 17, '00006', '2014-01-29', 'Wednesday', 1, '', 'R', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(129, 17, '00006', '2014-01-30', 'Thursday', 1, '', 'R', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(130, 17, '00006', '2014-01-31', 'Friday', 1, '', 'R', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(131, 17, '00006', '2014-02-01', 'Saturday', 1, '', 'R', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(132, 17, '00006', '2014-02-02', 'Sunday', 1, '', 'D', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(133, 17, '00006', '2014-02-03', 'Monday', 1, '', 'R', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(134, 17, '00006', '2014-02-04', 'Tuesday', 1, '', 'R', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(135, 17, '00006', '2014-02-05', 'Wednesday', 1, '', 'R', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(136, 17, '00006', '2014-02-06', 'Thursday', 1, '', 'R', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(137, 17, '00006', '2014-02-07', 'Friday', 1, '', 'R', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(138, 17, '00006', '2014-02-08', 'Saturday', 1, '', 'R', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(139, 17, '00006', '2014-02-09', 'Sunday', 1, '', 'D', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014'),
(140, 17, '00006', '2014-02-10', 'Monday', 1, '', 'R', 'N', '01', '', '07:00 AM', '04:00 PM', '8.50', '0.00', 3, '2014');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `nacionalidades`
--

CREATE TABLE IF NOT EXISTS `nacionalidades` (
  `id_nacionalidad` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_pais` varchar(100) DEFAULT NULL,
  `nacionalidad` varchar(100) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_nacionalidad`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Volcado de datos para la tabla `nacionalidades`
--

INSERT INTO `nacionalidades` (`id_nacionalidad`, `nombre_pais`, `nacionalidad`, `fecha_creacion`, `id_usuario`) VALUES
(1, 'PANAMA', 'PANAME&Ntilde;A', '2015-03-27 02:21:29', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `periodos`
--

CREATE TABLE IF NOT EXISTS `periodos` (
  `id_periodo` int(11) NOT NULL AUTO_INCREMENT,
  `anno_fiscal` varchar(100) DEFAULT NULL,
  `frecuencia_pago` varchar(100) DEFAULT NULL,
  `numero_control` varchar(100) DEFAULT NULL,
  `numero_periodo` int(11) DEFAULT NULL,
  `fecha_pago` date DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_final` date DEFAULT NULL,
  `secuencia_mensual` varchar(100) DEFAULT NULL,
  `estatus` int(11) DEFAULT NULL,
  `mostrar` int(11) NOT NULL DEFAULT '1',
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_periodo`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=36 ;

--
-- Volcado de datos para la tabla `periodos`
--

INSERT INTO `periodos` (`id_periodo`, `anno_fiscal`, `frecuencia_pago`, `numero_control`, `numero_periodo`, `fecha_pago`, `fecha_inicio`, `fecha_final`, `secuencia_mensual`, `estatus`, `mostrar`, `fecha_creacion`, `id_usuario`) VALUES
(1, '2014', 'QUINCENAL', NULL, 1, '2014-01-15', '2013-12-26', '2014-01-10', '2', 0, 1, '2015-06-03 14:24:50', 2),
(2, '2014', 'QUINCENAL', NULL, 2, '2014-01-30', '2014-01-11', '2014-01-25', '2', 0, 1, '2015-06-03 14:24:50', 2),
(3, '2014', 'QUINCENAL', NULL, 3, '2014-02-15', '2014-01-26', '2014-02-10', '2', 1, 1, '2015-06-04 22:52:57', 2),
(4, '2014', 'QUINCENAL', NULL, 4, '2014-02-28', '2014-02-11', '2014-02-25', '2', 0, 1, '2015-06-03 14:24:50', 2),
(5, '2014', 'QUINCENAL', NULL, 5, '2014-03-15', '2014-02-26', '2014-03-10', '2', 0, 1, '2015-06-03 14:24:50', 2),
(6, '2014', 'QUINCENAL', NULL, 6, '2014-03-30', '2014-03-11', '2014-03-25', '2', 0, 1, '2015-06-03 14:24:50', 2),
(7, '2014', 'QUINCENAL', NULL, 7, '2014-04-15', '2014-03-26', '2014-04-10', '2', 0, 1, '2015-06-03 14:24:50', 2),
(8, '2014', 'QUINCENAL', NULL, 8, '2014-04-30', '2014-04-11', '2014-04-25', '2', 0, 1, '2015-06-03 14:24:50', 2),
(9, '2014', 'QUINCENAL', NULL, 9, '2014-05-15', '2014-04-26', '2014-05-10', '2', 0, 1, '2015-06-03 14:24:50', 2),
(10, '2014', 'QUINCENAL', NULL, 10, '2014-05-30', '2014-05-11', '2014-05-25', '2', 0, 1, '2015-06-03 14:24:50', 2),
(11, '2014', 'QUINCENAL', NULL, 11, '2014-06-15', '2014-05-26', '2014-06-10', '2', 0, 1, '2015-06-03 14:24:50', 2),
(12, '2014', 'QUINCENAL', NULL, 12, '2014-06-30', '2014-06-11', '2014-06-25', '2', 0, 1, '2015-06-03 14:24:50', 2),
(13, '2014', 'QUINCENAL', NULL, 13, '2014-07-15', '2014-06-26', '2014-07-10', '2', 0, 1, '2015-06-03 14:24:50', 2),
(14, '2014', 'QUINCENAL', NULL, 14, '2014-07-30', '2014-07-11', '2014-07-25', '2', 0, 1, '2015-06-03 14:24:50', 2),
(15, '2014', 'QUINCENAL', NULL, 15, '2014-08-15', '2014-07-26', '2014-08-10', '2', 0, 1, '2015-06-03 14:24:50', 2),
(16, '2014', 'QUINCENAL', NULL, 16, '2014-08-30', '2014-08-11', '2014-08-25', '2', 0, 1, '2015-06-03 14:24:50', 2),
(17, '2014', 'QUINCENAL', NULL, 17, '2014-09-15', '2014-08-26', '2014-09-10', '2', 0, 1, '2015-06-03 14:24:50', 2),
(18, '2014', 'QUINCENAL', NULL, 18, '2014-09-30', '2014-09-11', '2014-09-25', '2', 0, 1, '2015-06-03 14:24:50', 2),
(19, '2014', 'QUINCENAL', NULL, 19, '2014-10-15', '2014-09-26', '2014-10-10', '2', 0, 1, '2015-06-03 14:24:50', 2),
(20, '2014', 'QUINCENAL', NULL, 20, '2014-10-30', '2014-10-11', '2014-10-25', '2', 0, 1, '2015-06-03 14:24:50', 2),
(21, '2014', 'QUINCENAL', NULL, 21, '2014-11-15', '2014-10-26', '2014-11-10', '2', 0, 1, '2015-06-03 14:24:50', 2),
(22, '2014', 'QUINCENAL', NULL, 22, '2014-11-30', '2014-11-11', '2014-11-25', '2', 0, 1, '2015-06-03 14:24:50', 2),
(23, '2014', 'QUINCENAL', NULL, 23, '2014-12-15', '2014-11-26', '2014-12-10', '2', 0, 1, '2015-06-03 14:24:50', 2),
(24, '2014', 'QUINCENAL', NULL, 24, '2014-12-30', '2014-12-11', '2014-12-25', '2', 0, 1, '2015-06-03 14:24:50', 2),
(25, '2015', 'QUINCENAL', NULL, 1, '2015-01-15', '2014-12-26', '2015-01-10', '2', 0, 1, '2015-06-03 14:24:50', 2),
(26, '2015', 'QUINCENAL', NULL, 2, '2015-01-30', '2015-01-11', '2015-01-25', '2', 0, 1, '2015-06-03 14:24:50', 2),
(27, '2015', 'QUINCENAL', NULL, 3, '2015-02-15', '2015-01-26', '2015-02-10', '2', 0, 1, '2015-06-03 14:24:50', 2),
(28, '2015', 'QUINCENAL', NULL, 4, '2015-02-28', '2015-02-11', '2015-02-25', '2', 0, 1, '2015-06-03 14:24:50', 2),
(29, '2015', 'QUINCENAL', NULL, 5, '2015-03-15', '2015-02-26', '2015-03-10', '2', 0, 1, '2015-06-03 14:24:50', 2),
(30, '2015', 'QUINCENAL', NULL, 6, '2015-03-30', '2015-03-11', '2015-03-25', '2', 0, 1, '2015-06-03 14:24:50', 2),
(31, '2015', 'QUINCENAL', NULL, 7, '2015-04-15', '2015-03-26', '2015-04-10', '2', 0, 1, '2015-06-03 14:24:50', 2),
(32, '2015', 'QUINCENAL', NULL, 8, '2015-04-30', '2015-04-11', '2015-04-25', '2', 0, 1, '2015-06-03 14:24:50', 2),
(33, '2015', 'QUINCENAL', NULL, 9, '2015-05-15', '2015-04-26', '2015-05-10', '2', 0, 1, '2015-06-03 14:24:50', 2),
(34, '2015', 'QUINCENAL', NULL, 10, '2015-05-30', '2015-05-11', '2015-05-25', '2', 0, 1, '2015-06-03 14:24:50', 2),
(35, '2015', 'QUINCENAL', NULL, 11, '2015-06-15', '2015-05-26', '2015-06-10', '2', 0, 1, '2015-06-04 22:53:19', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registros_transacciones_empleados`
--

CREATE TABLE IF NOT EXISTS `registros_transacciones_empleados` (
  `id_registro_transaccion_empleado` int(11) NOT NULL AUTO_INCREMENT,
  `id_empleado` int(11) DEFAULT NULL,
  `id_periodo` int(11) DEFAULT NULL,
  `horas_regular` varchar(100) DEFAULT NULL,
  `horas_domingo` varchar(100) DEFAULT NULL,
  `horas_feriado` varchar(100) DEFAULT NULL,
  `horas_compensatorio` varchar(100) DEFAULT NULL,
  `horas_extra1` varchar(100) DEFAULT NULL,
  `horas_extra2` varchar(100) DEFAULT NULL,
  `horas_extra3` varchar(100) DEFAULT NULL,
  `horas_extra4` varchar(100) DEFAULT NULL,
  `horas_extra5` varchar(100) DEFAULT NULL,
  `horas_extra6` varchar(100) DEFAULT NULL,
  `horas_extra7` varchar(100) DEFAULT NULL,
  `horas_extra8` varchar(100) DEFAULT NULL,
  `horas_extra9` varchar(100) DEFAULT NULL,
  `horas_extra10` varchar(100) DEFAULT NULL,
  `factor_reg` varchar(100) DEFAULT NULL,
  `factor_dom` varchar(100) DEFAULT NULL,
  `factor_fer` varchar(100) DEFAULT NULL,
  `factor_com` varchar(100) DEFAULT NULL,
  `factor1` varchar(100) DEFAULT NULL,
  `factor2` varchar(100) DEFAULT NULL,
  `factor3` varchar(100) DEFAULT NULL,
  `factor4` varchar(100) DEFAULT NULL,
  `factor5` varchar(100) DEFAULT NULL,
  `factor6` varchar(100) DEFAULT NULL,
  `factor7` varchar(100) DEFAULT NULL,
  `factor8` varchar(100) DEFAULT NULL,
  `factor9` varchar(100) DEFAULT NULL,
  `factor10` varchar(100) DEFAULT NULL,
  `horas_enferm` varchar(100) DEFAULT NULL,
  `horas_ajuste` varchar(100) DEFAULT NULL,
  `horas_ausen` varchar(100) DEFAULT NULL,
  `horas_certmedic` varchar(100) DEFAULT NULL,
  `adelanto_vacaciones` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_registro_transaccion_empleado`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Volcado de datos para la tabla `registros_transacciones_empleados`
--

INSERT INTO `registros_transacciones_empleados` (`id_registro_transaccion_empleado`, `id_empleado`, `id_periodo`, `horas_regular`, `horas_domingo`, `horas_feriado`, `horas_compensatorio`, `horas_extra1`, `horas_extra2`, `horas_extra3`, `horas_extra4`, `horas_extra5`, `horas_extra6`, `horas_extra7`, `horas_extra8`, `horas_extra9`, `horas_extra10`, `factor_reg`, `factor_dom`, `factor_fer`, `factor_com`, `factor1`, `factor2`, `factor3`, `factor4`, `factor5`, `factor6`, `factor7`, `factor8`, `factor9`, `factor10`, `horas_enferm`, `horas_ajuste`, `horas_ausen`, `horas_certmedic`, `adelanto_vacaciones`) VALUES
(1, 13, 3, '104.00', '16.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1.0000', '1.5000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 16, 3, '104.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1.0000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 17, 3, '104.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1.0000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(4, 18, 3, '104.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1.0000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE IF NOT EXISTS `roles` (
  `id_rol` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_rol` varchar(100) DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_rol`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id_rol`, `nombre_rol`, `descripcion`, `fecha_creacion`, `id_usuario`) VALUES
(1, 'Super Administrador', NULL, '2015-01-01 00:00:00', 1),
(2, 'Administrador', NULL, '2015-01-01 00:00:00', 1),
(3, 'Usuario', NULL, '2015-01-01 00:00:00', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `secciones`
--

CREATE TABLE IF NOT EXISTS `secciones` (
  `id_seccion` int(11) NOT NULL AUTO_INCREMENT,
  `id_departamento` int(11) DEFAULT NULL,
  `nombre_seccion` varchar(100) DEFAULT NULL,
  `codigo_seccion` varchar(100) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_seccion`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=65 ;

--
-- Volcado de datos para la tabla `secciones`
--

INSERT INTO `secciones` (`id_seccion`, `id_departamento`, `nombre_seccion`, `codigo_seccion`, `fecha_creacion`, `id_usuario`) VALUES
(1, 1, 'ADMINISTRACION', '0001', '2015-05-18 21:18:23', 2),
(2, 2, 'PRODUCCION', '0002', '2015-04-21 18:08:17', 1),
(3, 2, 'SEGURIDAD', '0003', '2015-04-21 18:08:17', 1),
(4, 2, 'MANTENIMIENTO', '0004', '2015-04-21 18:08:17', 1),
(5, 3, 'ADMINISTRACION', '0005', '2015-04-21 18:08:17', 1),
(6, 3, 'SEGURIDAD', '0006', '2015-04-21 18:08:17', 1),
(7, 3, 'MANTENIMIENTO', '0007', '2015-04-21 18:08:17', 1),
(8, 4, 'ADMINISTRACION', '0008', '2015-04-21 18:08:17', 1),
(9, 4, 'PRODUCCION', '0009', '2015-04-21 18:08:17', 1),
(10, 4, 'MANTENIMIENTO', '0010', '2015-04-21 18:08:18', 1),
(11, 5, 'PRODUCCION', '0011', '2015-04-21 18:08:18', 1),
(12, 5, 'SEGURIDAD', '0012', '2015-04-21 18:08:18', 1),
(13, 5, 'MANTENIMIENTO', '0013', '2015-04-21 18:08:18', 1),
(14, 6, 'MANTENIMIENTO', '0014', '2015-04-21 18:08:18', 1),
(15, 6, 'PRODUCCION', '0015', '2015-04-21 18:08:18', 1),
(16, 7, 'ADMINISTRACION', '0016', '2015-04-21 18:08:18', 1),
(17, 7, 'PRODUCCION', '0017', '2015-04-21 18:08:18', 1),
(18, 8, 'ADMINISTRACION', '0018', '2015-04-21 18:08:18', 1),
(19, 8, 'PRODUCCION', '0019', '2015-04-21 18:08:18', 1),
(20, 8, 'MANTENIMIENTO', '0020', '2015-04-21 18:08:18', 1),
(21, 9, 'MANTENIMIENTO', '0021', '2015-04-21 18:08:18', 1),
(22, 10, 'PRODUCCION', '0022', '2015-04-21 18:08:18', 1),
(23, 11, 'CONDUCTORES', '0023', '2015-04-21 18:08:18', 1),
(24, 7, 'SEGURIDAD', '0024', '2015-04-21 18:08:18', 1),
(25, 3, 'PRODUCCION', '0025', '2015-04-21 18:08:19', 1),
(26, 4, 'SEGURIDAD', '0026', '2015-04-21 18:08:19', 1),
(27, 12, 'MANTENIMIENTO', '0027', '2015-04-21 18:08:19', 1),
(28, 13, 'PRODUCCION', '0028', '2015-04-21 18:08:19', 1),
(29, 14, 'PRODUCCION', '0029', '2015-04-21 18:08:19', 1),
(30, 15, 'ADMINISTRACION', '0030', '2015-04-21 18:08:19', 1),
(31, 15, 'PRODUCCION', '0031', '2015-04-21 18:08:19', 1),
(32, 15, 'AYUDANTE GENERAL', '0032', '2015-04-21 18:08:19', 1),
(33, 15, 'MANTENIMIENTO', '0033', '2015-04-21 18:08:19', 1),
(34, 4, 'GANADERIA', '0034', '2015-04-21 18:08:19', 1),
(35, 4, 'JARDINERIA', '0035', '2015-04-21 18:08:19', 1),
(36, 5, 'GANADERIA', '0036', '2015-04-21 18:08:19', 1),
(37, 6, 'GANADERIA', '0037', '2015-04-21 18:08:19', 1),
(38, 7, 'GANADERIA', '0038', '2015-04-21 18:08:19', 1),
(39, 7, 'JARDINERIA', '0039', '2015-04-21 18:08:19', 1),
(40, 8, 'GANADERIA', '0040', '2015-04-21 18:08:19', 1),
(41, 10, 'GANADERIA', '0041', '2015-04-21 18:08:20', 1),
(42, 12, 'GANADERIA', '0042', '2015-04-21 18:08:20', 1),
(43, 12, 'PRODUCCION', '0043', '2015-04-21 18:08:20', 1),
(44, 13, 'GANADERIA', '0044', '2015-04-21 18:08:20', 1),
(45, 14, 'GANADERIA', '0045', '2015-04-21 18:08:20', 1),
(46, 7, 'MANTENIMIENTO', '0046', '2015-04-21 18:08:20', 1),
(47, 9, 'GANADERIA', '0047', '2015-04-21 18:08:20', 1),
(48, 16, 'MANTENIMIENTO', '0048', '2015-04-21 18:08:20', 1),
(49, 14, 'MANTENIMIENTO', '0049', '2015-04-21 18:08:20', 1),
(50, 17, 'SUPERVISOR', '0050', '2015-04-21 18:08:20', 1),
(51, 13, 'MANTENIMIENTO', '0051', '2015-04-21 18:08:20', 1),
(52, 18, 'PRODUCCION', '0052', '2015-04-21 18:08:20', 1),
(53, 19, 'PRODUCCION', '0053', '2015-04-21 18:08:20', 1),
(54, 20, 'PRODUCCION', '0054', '2015-04-21 18:08:20', 1),
(55, 21, 'PRODUCCION FALDARES', '0055', '2015-04-21 18:08:20', 1),
(56, 22, 'PRODUCCION AGROREY', '0056', '2015-04-21 18:08:20', 1),
(57, 23, 'PRODUCCION', '0057', '2015-04-21 18:08:21', 1),
(58, 23, 'MANTENIMIENTO', '0058', '2015-04-21 18:08:21', 1),
(59, 24, 'MANTENIMIENTO', '0059', '2015-04-21 18:08:21', 1),
(60, 25, 'PLANTA', '0060', '2015-04-21 18:08:21', 1),
(61, 29, 'DESHUESE', '0061', '2015-04-21 18:08:21', 1),
(62, 27, 'CARNE HARINA', '0062', '2015-04-21 18:08:21', 1),
(63, 28, 'VENTAS', '0063', '2015-04-21 18:08:21', 1),
(64, 26, 'SALA', '0064', '2015-04-21 18:08:21', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `talonarios_empleados`
--

CREATE TABLE IF NOT EXISTS `talonarios_empleados` (
  `id_talonario_empleado` int(11) NOT NULL AUTO_INCREMENT,
  `id_empleado` int(11) DEFAULT NULL,
  `numero_empleado` varchar(100) DEFAULT NULL,
  `id_periodo` int(11) DEFAULT NULL,
  `id_seccion` int(11) DEFAULT NULL,
  `nombre_seccion` varchar(100) DEFAULT NULL,
  `nombre_departamento` varchar(100) DEFAULT NULL,
  `nombre_empleado` varchar(100) DEFAULT NULL,
  `apellido_empleado` varchar(100) DEFAULT NULL,
  `cedula_empleado` varchar(100) DEFAULT NULL,
  `id_empresa` int(11) DEFAULT NULL,
  `nombre_empresa` varchar(100) DEFAULT NULL,
  `horas_regular` varchar(100) DEFAULT NULL,
  `horas_domingo` varchar(100) DEFAULT NULL,
  `horas_feriado` varchar(100) DEFAULT NULL,
  `horas_compensatorio` varchar(100) DEFAULT NULL,
  `horas_extra1` varchar(100) DEFAULT NULL,
  `horas_extra2` varchar(100) DEFAULT NULL,
  `horas_extra3` varchar(100) DEFAULT NULL,
  `horas_extra4` varchar(100) DEFAULT NULL,
  `horas_extra5` varchar(100) DEFAULT NULL,
  `horas_extra6` varchar(100) DEFAULT NULL,
  `horas_extra7` varchar(100) DEFAULT NULL,
  `horas_extra8` varchar(100) DEFAULT NULL,
  `horas_extra9` varchar(100) DEFAULT NULL,
  `horas_extra10` varchar(100) DEFAULT NULL,
  `factor_reg` varchar(100) DEFAULT NULL,
  `factor_dom` varchar(100) DEFAULT NULL,
  `factor_fer` varchar(100) DEFAULT NULL,
  `factor_com` varchar(100) DEFAULT NULL,
  `factor1` varchar(100) DEFAULT NULL,
  `factor2` varchar(100) DEFAULT NULL,
  `factor3` varchar(100) DEFAULT NULL,
  `factor4` varchar(100) DEFAULT NULL,
  `factor5` varchar(100) DEFAULT NULL,
  `factor6` varchar(100) DEFAULT NULL,
  `factor7` varchar(100) DEFAULT NULL,
  `factor8` varchar(100) DEFAULT NULL,
  `factor9` varchar(100) DEFAULT NULL,
  `factor10` varchar(100) DEFAULT NULL,
  `horas_enferm` varchar(100) DEFAULT NULL,
  `horas_ajuste` varchar(100) DEFAULT NULL,
  `horas_ausen` varchar(100) DEFAULT NULL,
  `rataxhora` varchar(100) DEFAULT NULL,
  `claveir` varchar(100) DEFAULT NULL,
  `seg_soc` varchar(100) DEFAULT NULL,
  `seg_edu` varchar(100) DEFAULT NULL,
  `isr` varchar(100) DEFAULT NULL,
  `cod1` varchar(100) DEFAULT NULL,
  `cod2` varchar(100) DEFAULT NULL,
  `cod3` varchar(100) DEFAULT NULL,
  `cod4` varchar(100) DEFAULT NULL,
  `cod5` varchar(100) DEFAULT NULL,
  `cod6` varchar(100) DEFAULT NULL,
  `cod7` varchar(100) DEFAULT NULL,
  `cod8` varchar(100) DEFAULT NULL,
  `cod9` varchar(100) DEFAULT NULL,
  `cod10` varchar(100) DEFAULT NULL,
  `monto1` varchar(100) DEFAULT NULL,
  `monto2` varchar(100) DEFAULT NULL,
  `monto3` varchar(100) DEFAULT NULL,
  `monto4` varchar(100) DEFAULT NULL,
  `monto5` varchar(100) DEFAULT NULL,
  `monto6` varchar(100) DEFAULT NULL,
  `monto7` varchar(100) DEFAULT NULL,
  `monto8` varchar(100) DEFAULT NULL,
  `monto9` varchar(100) DEFAULT NULL,
  `monto10` varchar(100) DEFAULT NULL,
  `monto_pend1` varchar(100) DEFAULT NULL,
  `monto_pend2` varchar(100) DEFAULT NULL,
  `monto_pend3` varchar(100) DEFAULT NULL,
  `monto_pend4` varchar(100) DEFAULT NULL,
  `monto_pend5` varchar(100) DEFAULT NULL,
  `monto_pend6` varchar(100) DEFAULT NULL,
  `monto_pend7` varchar(100) DEFAULT NULL,
  `monto_pend8` varchar(100) DEFAULT NULL,
  `monto_pend9` varchar(100) DEFAULT NULL,
  `monto_pend10` varchar(100) DEFAULT NULL,
  `numero_comprobante` varchar(100) DEFAULT NULL,
  `sal_deve_vacaciones` varchar(100) DEFAULT NULL,
  `sal_deve_xiiimes` varchar(100) DEFAULT NULL,
  `acu_pago_vacaciones` varchar(100) DEFAULT NULL,
  `acu_pago_xiiimes` varchar(100) DEFAULT NULL,
  `numero_cuenta` varchar(100) DEFAULT NULL,
  `id_tipo_cuenta` int(11) DEFAULT NULL,
  `id_banco` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_talonario_empleado`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Volcado de datos para la tabla `talonarios_empleados`
--

INSERT INTO `talonarios_empleados` (`id_talonario_empleado`, `id_empleado`, `numero_empleado`, `id_periodo`, `id_seccion`, `nombre_seccion`, `nombre_departamento`, `nombre_empleado`, `apellido_empleado`, `cedula_empleado`, `id_empresa`, `nombre_empresa`, `horas_regular`, `horas_domingo`, `horas_feriado`, `horas_compensatorio`, `horas_extra1`, `horas_extra2`, `horas_extra3`, `horas_extra4`, `horas_extra5`, `horas_extra6`, `horas_extra7`, `horas_extra8`, `horas_extra9`, `horas_extra10`, `factor_reg`, `factor_dom`, `factor_fer`, `factor_com`, `factor1`, `factor2`, `factor3`, `factor4`, `factor5`, `factor6`, `factor7`, `factor8`, `factor9`, `factor10`, `horas_enferm`, `horas_ajuste`, `horas_ausen`, `rataxhora`, `claveir`, `seg_soc`, `seg_edu`, `isr`, `cod1`, `cod2`, `cod3`, `cod4`, `cod5`, `cod6`, `cod7`, `cod8`, `cod9`, `cod10`, `monto1`, `monto2`, `monto3`, `monto4`, `monto5`, `monto6`, `monto7`, `monto8`, `monto9`, `monto10`, `monto_pend1`, `monto_pend2`, `monto_pend3`, `monto_pend4`, `monto_pend5`, `monto_pend6`, `monto_pend7`, `monto_pend8`, `monto_pend9`, `monto_pend10`, `numero_comprobante`, `sal_deve_vacaciones`, `sal_deve_xiiimes`, `acu_pago_vacaciones`, `acu_pago_xiiimes`, `numero_cuenta`, `id_tipo_cuenta`, `id_banco`) VALUES
(1, 18, '00002', 3, 10, 'MANTENIMIENTO', 'MARGARITA', 'DIDIMO IVAN', 'VALDEZ', '9999-999', 6, 'IRBRO', '104.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1.0000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1.87', 'A-0', '18.96', '2.43', '0.00', 'BAC', 'BG', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '10.00', '5.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '100.00', '50.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0401027778889', 4, 1),
(2, 13, '00004', 3, 10, 'MANTENIMIENTO', 'MARGARITA', 'ROSA EVELIA', 'MARTINEZ', '9-125-1252', 6, 'IRBRO', '104.00', '16.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1.0000', '1.5000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1.62', 'A-0', '20.22', '2.59', '0.00', 'COPERA', 'BG', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '7.00', '5.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '200.00', '100.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0401026667779', 4, 1),
(3, 17, '00006', 3, 10, 'MANTENIMIENTO', 'MARGARITA', 'CATALINO', 'RODRIGUEZ MAGALLON', '9999-999', 6, 'IRBRO', '104.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1.0000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1.62', 'A-0', '16.43', '2.11', '0.00', '1-LG', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '25.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '500.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0401025556669', 4, 1),
(4, 16, '00007', 3, 10, 'MANTENIMIENTO', 'MARGARITA', 'BASILIDES', 'RODRIGUEZ', '2-102-2071', 6, 'IRBRO', '104.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1.0000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1.62', 'E-3', '16.43', '2.11', '0.00', 'BG', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '50.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1000.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0401024445559', 4, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_sangres`
--

CREATE TABLE IF NOT EXISTS `tipos_sangres` (
  `id_tipo_sangre` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_sangre` varchar(100) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_tipo_sangre`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `turnos`
--

CREATE TABLE IF NOT EXISTS `turnos` (
  `id_turno` int(11) NOT NULL AUTO_INCREMENT,
  `turno` varchar(100) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_turno`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE IF NOT EXISTS `usuarios` (
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `id_rol` int(11) DEFAULT NULL,
  `id_estado_usuario` int(11) DEFAULT NULL,
  `nombre_usuario` varchar(100) DEFAULT NULL,
  `pwd` varchar(100) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `id_rol`, `id_estado_usuario`, `nombre_usuario`, `pwd`, `fecha_creacion`) VALUES
(1, 2, 1, 'Usuario2', '123', '2015-03-27 01:44:12'),
(2, 1, 1, 'Usuario1', '123', '2015-03-27 01:44:12'),
(3, 2, 1, 'Usuario3', '123', '2015-03-27 11:14:51'),
(4, 1, 1, 'usuario4', '123', '2015-03-27 11:12:17'),
(5, 1, 1, 'usaurio5', '12345', '2015-03-27 11:10:36');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
