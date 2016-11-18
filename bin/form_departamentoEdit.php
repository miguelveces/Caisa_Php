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
	$id_departamento = isset($_POST['id']) ? mysqli_real_escape_string($connect, $_POST['id']) :  "";
    $codigo_departamento = isset($_POST['coddepartment']) ? mysqli_real_escape_string($connect, $_POST['coddepartment']) :  "";
	$nombre_departamento = isset($_POST['namedepartment']) ? mysqli_real_escape_string($connect, $_POST['namedepartment']) :  "";
	$id_usuario= isset($_SESSION['id_usuario']) ? mysqli_real_escape_string($connect, $_SESSION['id_usuario']) :  "";
	//$codigo_peachtree = isset($_POST['roles']) ? mysqli_real_escape_string($connect, $_POST['roles']) :  "";
    //Give it value at parameter 
    $param = array('id_departamento' => $id_departamento,'codigo_departamento' => $codigo_departamento,'nombre_departamento' => $nombre_departamento,'id_usuario' => $id_usuario); 
	$result = $client->call('EditDepartmentByid',$param,'','','',true);


}
else
{
$id_departamento = isset($_GET['id']) ? mysqli_real_escape_string($connect, $_GET['id']) :  "";
$param = array('id_departamento' => $id_departamento); 
$result = $client->call('GetDepartmentByid',$param,'','','',true);



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