<?php
session_start();
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

include_once('../reports/class/tcpdf/tcpdf.php');
include_once("../reports/class/PHPJasperXML.inc.php");
include_once ('../reports/class/setting.php');


$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");
$xml =  simplexml_load_file("../reports/PlanillaQuincenal.jrxml");
//$xml =  simplexml_load_file("../reports/ComprobanteEmpleados.jrxml");
//$xml =  simplexml_load_file("../reports/report1.jrxml");


/*$id_periodo=3;
$numero_periodo=2;
$fecha_desde="11/01/2015";
$fecha_hasta="25/01/2015";
$id_empresa = 6;*/

	 
	 $id_periodo = isset($_GET['id']) ? mysqli_real_escape_string($connect, $_GET['id']) :  "";
	 $numero_periodo = isset($_GET['numberperiodo']) ? mysqli_real_escape_string($connect, $_GET['numberperiodo']) :  "";
	 $fecha_desde = isset($_GET['dated']) ? mysqli_real_escape_string($connect, $_GET['dated']) :  "";
	 $fecha_hasta = isset($_GET['dateh']) ? mysqli_real_escape_string($connect, $_GET['dateh']) :  "";
	 $id_empresa = $_SESSION['id_empresa']; 



	  
//$PHPJasperXML = new PHPJasperXML("en","TCPDF");
$PHPJasperXML = new PHPJasperXML();
$PHPJasperXML->arrayParameter=array("id_periodo" => $id_periodo,"numero_periodo"=>$numero_periodo,"fecha_desde"=>$fecha_desde,"fecha_hasta"=>$fecha_hasta,"id_empresa"=>$id_empresa,"SUBREPORT_DIR"=>$folder);
$PHPJasperXML->debugsql=false;
$PHPJasperXML->xml_dismantle($xml);

$PHPJasperXML->transferDBtoArray($server,$user,$pass,$db);

$PHPJasperXML->outpage("I");    //page output method I:standard output  D:Download file

	
?>