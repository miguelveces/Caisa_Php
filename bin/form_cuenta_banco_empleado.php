<?php
session_start();
//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/demos/WSCaisa/MyService.php?wsdl";

//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$result="";
$resultEmployee="";
$resultBanks="";
$param = array(); 
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");
if($_SERVER['REQUEST_METHOD'] == "POST"){
    // Get data
	$id_empleado = isset($_POST['id']) ? mysqli_real_escape_string($connect, $_POST['id']) :  "";
    $numero_empleado = isset($_POST['numemployee']) ? mysqli_real_escape_string($connect, $_POST['numemployee']) :  "";
	//$pwd = isset($_POST['nameemployee']) ? mysqli_real_escape_string($connect, $_POST['nameemployee']) :  "";
	$numero_cuenta = isset($_POST['numbank']) ? mysqli_real_escape_string($connect, $_POST['numbank']) :  "";
	$id_tipo_cuenta = isset($_POST['idtypecta']) ? mysqli_real_escape_string($connect, $_POST['idtypecta']) :  "";
	$nombre_tipo_cuenta = isset($_POST['typecta']) ? mysqli_real_escape_string($connect, $_POST['typecta']) :  "";
	$id_banco = isset($_POST['banks']) ? mysqli_real_escape_string($connect, $_POST['banks']) :  "";
	$tipo_tranferencia="ACH";
    //Give it value at parameter
    $id_cuenta_banco_empleado = isset( $_SESSION['id_cuenta_banco_empleado']) ? mysqli_real_escape_string($connect,  $_SESSION['id_cuenta_banco_empleado']) :  "";	
	unset($_SESSION['id_cuenta_banco_empleado']);
	
	if($id_cuenta_banco_empleado==null)
	{    
		$param = array('id_empleado' => $id_empleado,'numero_empleado' => $numero_empleado,'numero_cuenta' => $numero_cuenta,'id_tipo_cuenta' => $id_tipo_cuenta,'nombre_tipo_cuenta' => $nombre_tipo_cuenta,'tipo_tranferencia' => $tipo_tranferencia,'id_banco' => $id_banco); 
		$result = $client->call('AddBankAccount',$param,'','','',true);}
	else
	{    
		$param = array('id_empleado' => $id_empleado,'numero_cuenta' => $numero_cuenta,'id_tipo_cuenta' => $id_tipo_cuenta,'nombre_tipo_cuenta' => $nombre_tipo_cuenta,'id_banco' => $id_banco); 
		$result = $client->call('EditBankAccountByidEmployee',$param,'','','',true);
	}

}
else
{
$id_empleado = isset($_GET['id']) ? mysqli_real_escape_string($connect, $_GET['id']) :  "";
$param = array('id_empleado' => $id_empleado); 
$result = $client->call('GetBankAccountByidEmployee',$param,'','','',true);

$_SESSION['id_cuenta_banco_empleado']=$result[0]['id_cuenta_banco_empleado'];

$banks = $client->call('GetAllBanks',$param,'','','',true);
 foreach($banks as $bank){ 
    $resultBanks.='<option value='.$bank['id_banco'].' '.($bank['id_banco'] == $result[0]['id_banco'] ? 'selected="selected"' : "").'>'.$bank['nombre_banco'].'</option>';
 } 

		if($result[0]['id_cuenta_banco_empleado']!=null)
		{
			 $json = array("status" => 1, "info" => $result, "banks" => $resultBanks);
		}
		else
		{
			$param = array('id_empleado' => $id_empleado); 
			$resultEmployee = $client->call('GetEmployeeByid',$param,'','','',true);
			$results[] = array("numero_empleado" => $resultEmployee[0]['numero_empleado'], "nombre" => $resultEmployee[0]['nombre'].' '.$resultEmployee[0]['apellido'],"numero_cuenta" => "","id_tipo_cuenta" => 4);
			$json = array("status" => 1, "info" => $results, "banks" => $resultBanks);
		
		}


 header('Content-type: application/json');
 //$json = array("status" => 1, "info" => $result, "banks" => $resultBanks);
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