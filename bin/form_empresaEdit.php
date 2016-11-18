<?php
session_start();
//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";

//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$result="";
$param = array(); 
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");
if($_SERVER['REQUEST_METHOD'] == "POST"){
    // Get data
	$id_empresa = isset($_POST['numcompany']) ? mysqli_real_escape_string($connect, $_POST['numcompany']) :  "";
	$nombre_empresa = isset($_POST['namecompany']) ? mysqli_real_escape_string($connect, $_POST['namecompany']) :  "";
	$representante_legal = isset($_POST['legalrepres']) ? mysqli_real_escape_string($connect, $_POST['legalrepres']) :  "";
	$direccion = isset($_POST['address']) ? mysqli_real_escape_string($connect, $_POST['address']) :  "";
	$apartado_postal = isset($_POST['zip']) ? mysqli_real_escape_string($connect, $_POST['zip']) :  "";
	$comentario = isset($_POST['comment']) ? mysqli_real_escape_string($connect, $_POST['comment']) :  "";
	$telefono_1 = isset($_POST['phone']) ? mysqli_real_escape_string($connect, $_POST['phone']) :  "";
	$codigo_actividad = isset($_POST['activitycode']) ? mysqli_real_escape_string($connect, $_POST['activitycode']) :  "";

    //Give it value at parameter 
    $param = array('id_empresa' => $id_empresa,'nombre_empresa' => $nombre_empresa,'representante_legal' => $representante_legal,
	'direccion' => $direccion,'apartado_postal' => $apartado_postal,'comentario' => $comentario,
	'telefono_1' => $telefono_1,'codigo_actividad' => $codigo_actividad); 
	$result = $client->call('EditCompanyByid',$param,'','','',true);

}
else
{
$id_empresa = isset($_GET['id']) ? mysqli_real_escape_string($connect, $_GET['id']) :  "";
$param = array('id_empresa' => $id_empresa); 
$result = $client->call('GetCompanyByid',$param,'','','',true);



 header('Content-type: application/json');
 $json = array("status" => 1, "info" => $result);
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