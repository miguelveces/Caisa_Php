<?php
session_start();
$result="";
$result='<div class="modal hide fade" id="pleaseWaitDialog"  data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog">
					<div class="modal-header">
					<h1>Por favor espere un momento...</h1>
					</div>
					<div class="modal-body">
						<div class="progress progress-striped active">
							<div class="bar" style="width: 100%;"></div>
						</div>
					</div>
				</div>';

header('Content-type: application/json');
$json = array("status" => 1, "info" => $result);
echo json_encode($json);
	
?>