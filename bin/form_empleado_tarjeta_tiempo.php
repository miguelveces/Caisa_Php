<?php
session_start();
//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";

//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$result="";
$json="";
$resultPeriod="";
$resultAdd="";
$resultWorkingDayEmployee="";
$param = array();
$paramAdd = array(); 
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");
if($_SERVER['REQUEST_METHOD'] == "POST"){
    // Get data


}
else
{
	$id_empleado = isset($_GET['id']) ? mysqli_real_escape_string($connect, $_GET['id']) :  "";
	$param = array('id_empleado' => $id_empleado); 
	$result = $client->call('GetEmployeeByid',$param,'','','',true);
    $numero_empleado=$result[0]['numero_empleado'];
    
	$param = array(); 
	$resultPeriod = $client->call('GetPeriodByStatus',$param,'','','',true);
    $id_periodo=$resultPeriod[0]['id_periodo'];
	$anno_fiscal=$resultPeriod[0]['anno_fiscal'];
	 
	$param = array('id_empleado' => $id_empleado,'id_periodo' => $id_periodo,'anno_fiscal' => $anno_fiscal); 
	$resultWorkingDayEmployee= $client->call('GetWorkingDayEmployeeByPeriod',$param,'','','',true);
	if($resultWorkingDayEmployee[0]['id_jornada_empleado']==null)
	{
	 $json = array("status" => 1);
	}
	else
	{
	 $json = array("status" => 2,"info" => $result,"period" =>$resultPeriod,"workingday" =>$resultWorkingDayEmployee);
	}
	
	/*if($resultWorkingDayEmployee[0]['id_jornada_empleado']==null) 
	{
		$date1=new DateTime($resultPeriod[0]['fecha_inicio']);
		$date2=new DateTime($resultPeriod[0]['fecha_final']);
		$date= $date1->diff($date2);
		for ($x = 0; $x <= $date->format('%d'); $x++) 
		{
			$date1=new DateTime($resultPeriod[0]['fecha_inicio']);
			$date1=$date1->add(new DateInterval('P'.$x.'D'));
			$fecha=$date1->format('Y-m-d');
			$dia=$date1->format('l');
			$laboro="1";
			$ausencia="";
			$tipo="R";
			if($dia=="Sunday"){$tipo="D";$laboro="0";}
			$codigo="N";
			$codigo_jornada="01";
			$com="";
			$hora_entra="07:00 AM";
			$hora_sale="04:00 PM";
			$horas_regulares="8.50";
			$horas_extras="0.00";
			//Give it value at parameter 
			$param = array('id_empleado' =>$id_empleado,'numero_empleado' =>$numero_empleado,
							'fecha' => $fecha,'dia' => $dia,'laboro' =>$laboro,'ausencia' => $ausencia,
							'tipo' => $tipo,'codigo' => $codigo,'codigo_jornada' => $codigo_jornada,'com'=> $com,
							'hora_entra' => $hora_entra,'hora_sale' => $hora_sale,'horas_regulares' => $horas_regulares,
							'horas_extras' => $horas_extras,'id_periodo' => $id_periodo,'anno_fiscal' => $anno_fiscal);
			$resultAdd = $client->call('AddWorkingDayEmployee',$param,'','','',true);
		
		}
		$param = array('id_empleado' => $id_empleado,'id_periodo' => $id_periodo,'anno_fiscal' => $anno_fiscal); 
		$resultWorkingDayEmployee= $client->call('GetWorkingDayEmployeeByPeriod',$param,'','','',true);
	}*/


 header('Content-type: application/json');
 echo json_encode($json);
 exit();
}
// fault if any
if ($client->fault) {
    echo 'Fault';
    print_r($result);
    echo '';
} 
else 
{
// Check for errors
    $err = $client->getError();
    if ($err) {
        // Display the error
        echo 'Error:'.$err;
    } 
	else 
	{
        // Display the result
        if($result!=false)
         {
		    header('Content-type: application/json');
			if($result[0]['msg']=='OK')
			{
				$json = array("status" => 1, "info" => $result);
				
			}
			else
			{
				$json = array("status" => 0, "info" => $result);
				
				
			}
			echo json_encode($json);
         }
    }
}		
?>