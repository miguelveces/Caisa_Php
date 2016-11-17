<?php
session_start();
//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/demos/WSCaisa/MyService.php?wsdl";

//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$result="";
$resultDepartments="";
$param = array(); 
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");
if($_SERVER['REQUEST_METHOD'] == "POST"){
    // Get data
    $codigo_seccion = isset($_POST['codseccion']) ? mysqli_real_escape_string($connect, $_POST['codseccion']) :  "";
	$nombre_seccion = isset($_POST['nameseccion']) ? mysqli_real_escape_string($connect, $_POST['nameseccion']) :  "";
	$id_departamento = isset($_POST['depart']) ? mysqli_real_escape_string($connect, $_POST['depart']) :  "";
	$id_usuario= isset($_SESSION['id_usuario']) ? mysqli_real_escape_string($connect, $_SESSION['id_usuario']) :  "";
	//$codigo_peachtree = isset($_POST['roles']) ? mysqli_real_escape_string($connect, $_POST['roles']) :  "";
    //Give it value at parameter 
    $param = array('codigo_seccion' => $codigo_seccion,'nombre_seccion' => $nombre_seccion, 'id_departamento' => $id_departamento,'id_usuario' => $id_usuario); 
	$result = $client->call('AddSection',$param,'','','',true);

}
else
{
	//GetAllDepartments
	
		$depart = $client->call('GetAllDepartments',$param,'','','',true);
	foreach($depart as $dep){ 
		$resultDepartments.='<option value='.$dep['id_departamento'].'>'.$dep['nombre_departamento'].'</option>';
	} 
 header('Content-type: application/json');
 $json = array("status" => 1, "depart" => $resultDepartments);
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
			if($result[0]['msg']!='OK')
			{
				$json = array("status" => 0, "info" => $result);
				
			}
			else
			{
				$json = array("status" => 1, "info" => $result);
				
				
			}
			echo json_encode($json);
         }
    }
}		
?>