<?php
session_start();
$result="";
$result='<div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
            <h2 id="lbl_title"></h2>
            </div>
            <div class="modal-body alert-danger">
                <h3 id="lbl_body"></h3>
			   
            </div>
            <div class="modal-footer">
			    <a href="#"  id="btn-ok" class="btn btn-danger"> Si </a>
                <button type="button" class="btn btn-default" data-dismiss="modal"> No </button>
        </div>
    </div>
  </div>';
header('Content-type: application/json');
$json = array("status" => 1, "info" => $result);
echo json_encode($json);
	
?>