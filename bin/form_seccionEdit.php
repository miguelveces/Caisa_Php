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
	
    $id_seccion = isset($_POST['id']) ? mysqli_real_escape_string($connect, $_POST['id']) :  "";
    $codigo_seccion = isset($_POST['codseccion']) ? mysqli_real_escape_string($connect, $_POST['codseccion']) :  "";
	$nombre_seccion = isset($_POST['nameseccion']) ? mysqli_real_escape_string($connect, $_POST['nameseccion']) :  "";
	$id_departamento = isset($_POST['depart']) ? mysqli_real_escape_string($connect, $_POST['depart']) :  "";
	$id_usuario= isset($_SESSION['id_usuario']) ? mysqli_real_escape_string($connect, $_SESSION['id_usuario']) :  "";
	//$codigo_peachtree = isset($_POST['roles']) ? mysqli_real_escape_string($connect, $_POST['roles']) :  "";
    //Give it value at parameter 
    $param = array('id_seccion'=> $id_seccion, 'id_departamento' => $id_departamento,'nombre_seccion' => $nombre_seccion,'codigo_seccion' => $codigo_seccion, 'id_usuario' => $id_usuario); 
	$result = $client->call('EditSectionByid',$param,'','','',true);


}
else
{
    $id_seccion = isset($_GET['id']) ? mysqli_real_escape_string($connect, $_GET['id']) :  "";
	$param = array('id_seccion' => $id_seccion);
	$result = $client->call('GetSectionByid',$param,'','','',true);
	
	/*$depart = $client->call('GetAllDepartments',$param,'','','',true);
	foreach($depart as $dep){ 
		$resultDepartments.='<option value='.$dep['id_departamento'].'>'.$dep['nombre_departamento'].'</option>';
	
	}*/

	$depart = $client->call('GetAllDepartments',$param,'','','',true);
	foreach($depart as $dep){
		$resultDepartments.='<option value='.$dep['id_departamento'].' '.($dep['id_departamento'] == $result[0]['id_departamento'] ? 'selected="selected"' : "").'>'.$dep['nombre_departamento'].'</option>';
	}	
	
	
	
 header('Content-type: application/json');
 $json = array("status" => 1, "info"=> $result,"depart" => $resultDepartments);
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