<?php
// This program is free software; you can redistribute it and/or modify
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

require_once(dirname(__FILE__) . "/includes/funcLib.php");
require_once(dirname(__FILE__) . "/includes/MySmarty.class.php");
$smarty = new MySmarty();
$opt = $smarty->opt();

session_start();
if (!isset($_SESSION["userid"])) {
	header("Location: " . getFullPath("login.php") . "?from=help.php");
	exit;
}
else {
	$userid = $_SESSION["userid"];
}

$action = "";
if (!empty($_POST["action"])) {
	$action = $_POST["action"];

	if ($action == "save") {
		if (!empty($_POST["show_helptext"]))
			$show_helptext = ($_POST["show_helptext"] == "on" ? 1 : 0);
		else
			$show_helptext = 0;

		try {
			$stmt = $smarty->dbh()->prepare("UPDATE {$opt["table_prefix"]}users SET show_helptext = ? WHERE userid = ?");
			$stmt->bindParam(1, $show_helptext, PDO::PARAM_BOOL);
			$stmt->bindParam(2, $userid, PDO::PARAM_INT);
			$stmt->execute();
		}
		catch (PDOException $e) {
			die("sql exception: " . $e->getMessage());
		}
	}
	else {
		die("Unknown verb.");
	}
}

try {
	$stmt = $smarty->dbh()->prepare("SELECT show_helptext FROM {$opt["table_prefix"]}users WHERE userid = ?");
	$stmt->bindParam(1, $userid, PDO::PARAM_INT);

	$stmt->execute();
	if ($row = $stmt->fetch()) {
		$smarty->assign('show_helptext', $row["show_helptext"]);
		$_SESSION['show_helptext'] = $row["show_helptext"];
	}
	else {
		die("You don't exist.");
	}
}
catch (PDOException $e) {
	die("sql exception: " . $e->getMessage());
}

$smarty->assign('myurl', "{$_SERVER['REQUEST_SCHEME']}://{$_SERVER['HTTP_HOST']}");
$smarty->display('help.tpl');

?>
