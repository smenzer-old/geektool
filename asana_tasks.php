<?php

require_once("asana.php");

$asana = new Asana("jdm5Dwv.DtJ1ItUjfZBtlgnzEcUfDZx2");

$tasks = json_decode($asana->getWorkspaceTasks(4417485436211));

$names = array();
$dues = array();
if (isset($tasks->data) && (is_array($tasks->data) || is_object($tasks->data))) {
	foreach ($tasks->data as $t) {
		$task = json_decode($asana->getTask($t->id));
		if (isset($task->data) && (is_array($task->data) || is_object($task->data))) {
			$names[$task->data->id] = $task->data->name;
			$dues[$task->data->id] = (isset($task->data->due_on)) ? $task->data->due_on : "0000-00-00";
		} else {
			echo "task failed";
		}
	}
} else {
	"task list failed";
}

asort($dues);

$no_date_str = "";
foreach ($dues as $id => $due) {
	if ($due != "0000-00-00") {
		echo "[$due]\t{$names[$id]}\n";
	} else {
		$no_date_str .= "\t\t\t\t\t{$names[$id]}\n";
	}
}
echo $no_date_str;
