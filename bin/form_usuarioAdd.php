<?php
session_start();
//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";

//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$result="";
$resultRoles="";
$resultStates="";
$param = array(); 
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");
if($_SERVER['REQUEST_METHOD'] == "POST"){
    // Get data
    $nombre_usuario = isset($_POST['user']) ? mysqli_real_escape_string($connect, $_POST['user']) :  "";
	$pwd = isset($_POST['pass']) ? mysqli_real_escape_string($connect, $_POST['pass']) :  "";
	$id_rol = isset($_POST['roles']) ? mysqli_real_escape_string($connect, $_POST['roles']) :  "";
	$id_estado_usuario = isset($_POST['states']) ? mysqli_real_escape_string($connect, $_POST['states']) :  "";
    //Give it value at parameter 
    $param = array('id_rol' => $id_rol,'nombre_usuario' => $nombre_usuario,'pwd' => $pwd,'id_estado_usuario' => $id_estado_usuario); 
	$result = $client->call('AddUser',$param,'','','',true);

}
else
{
	$roles = $client->call('GetAllRoles',$param,'','','',true);
	foreach($roles as $rol){ 
		$resultRoles.='<option value='.$rol['id_rol'].'>'.$rol['nombre_rol'].'</option>';
	} 
	
	$states = $client->call('GetAllStatesUsers',$param,'','','',true); 
	foreach($states as $state){ 
		$resultStates.='<option value='.$state['id_estado_usuario'].'>'.$state['nombre_estado_usuario'].'</option>';
	} 
 header('Content-type: application/json');
 $json = array("status" => 1, "roles" => $resultRoles, "states" => $resultStates);
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