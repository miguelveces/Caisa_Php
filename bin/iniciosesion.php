<?php
session_start();

//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
 set_time_limit (600);
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$result="";
$companies="";
$id_company;
$param = array(); 
$parame = array(); 
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");

if($_SERVER['REQUEST_METHOD'] == "POST"){
    // Get data
	$id_company = isset($_POST['company']) ? mysqli_real_escape_string($connect, $_POST['company']) :  "";
    $nombre_usuario = isset($_POST['user']) ? mysqli_real_escape_string($connect, $_POST['user']) :  "";
	$pwd = isset($_POST['pass']) ? mysqli_real_escape_string($connect, $_POST['pass']) :  "";
	
    //Give it value at parameter 
    $param = array('nombre_usuario' => $nombre_usuario,'pwd' => $pwd); 
	$result = $client->call('GetUserByName',$param,'','','',true);
	$companies = $client->call('GetAllCompanies',$parame,'','','',true);
}
else
{
	$companies = $client->call('GetAllCompanies',$param,'','','',true);
	foreach($companies as $company){ 
		if($company['codigo_actividad']){
			$result.='<option value='.$company['id_empresa'].'>'.$company['nombre_empresa'].'</option>';
		}
	} 
	
	header('Content-type: application/json');
	$json = array("status" => 1, "company" => $result);
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
			if($result[0]['id_usuario']==null)
			{
				$json = array("status" => 0, "info" => $result);
				
			}
			else
			{
			    $_SESSION['id_usuario']=$result[0]['id_usuario'];
				$_SESSION['id_rol']=$result[0]['id_rol'];
				$_SESSION['id_empresa']=$companies[$id_company -1]['id_empresa'];
				$_SESSION['nombre_empresa']=$companies[$id_company -1]['nombre_empresa'];
				$json = array("status" => 1, "info" => $result);
				
					
			}
			echo json_encode($json);
         }
    }
}		
?>