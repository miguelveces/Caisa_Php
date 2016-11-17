<?php
session_start();
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
include_once('../reports/class/tcpdf/tcpdf.php');
include_once("../reports/class/PHPJasperXML.inc.php");
include_once ('setting.php');

$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");
$xml =  simplexml_load_file("../reports/InformeBancoEmpleados.jrxml");

	 $id_periodo = isset($_GET['id']) ? mysqli_real_escape_string($connect, $_GET['id']) :  "";
	 $numero_periodo = isset($_GET['numberperiod']) ? mysqli_real_escape_string($connect, $_GET['numberperiod']) :  "";
	 $fecha_inicio = isset($_GET['dated']) ? mysqli_real_escape_string($connect, $_GET['dated']) :  "";
	 $fecha_final = isset($_GET['dateh']) ? mysqli_real_escape_string($connect, $_GET['dateh']) :  "";
	 $fecha_pago= isset($_GET['datepay']) ? mysqli_real_escape_string($connect, $_GET['datepay']) :  "";
	 $id_empresa = $_SESSION['id_empresa']; 

	 
//$PHPJasperXML = new PHPJasperXML("en","TCPDF");
$PHPJasperXML = new PHPJasperXML();
$PHPJasperXML->arrayParameter=array("id_periodo" => $id_periodo,"numero_periodo"=>$numero_periodo,"fecha_inicio"=>$fecha_inicio,"fecha_final"=>$fecha_final,"fecha_pago"=>$fecha_pago,"id_empresa"=>$id_empresa);
$PHPJasperXML->debugsql=false;
$PHPJasperXML->xml_dismantle($xml);

$PHPJasperXML->transferDBtoArray($server,$user,$pass,$db);

$PHPJasperXML->outpage("I");    //page output method I:standard output  D:Download file

	
?>