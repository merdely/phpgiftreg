<?php
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
	header("Location: " . getFullPath("login.php") . "?from=ranks.php");
	exit;
}
else if ($_SESSION["admin"] != 1) {
	echo "You don't have admin privileges.";
	exit;
}
else {
	$userid = $_SESSION["userid"];
}
if (!empty($_GET["message"])) {
	$message = filter_var(trim($_GET["message"], FILTER_SANITIZE_STRING));;
	$message = htmlspecialchars($message, ENT_QUOTES, 'UTF-8');
}

if (isset($_GET["ranking"])) {
	$ranking = filter_var(trim($_GET["ranking"]), FILTER_SANITIZE_NUMBER_INT);

	if (filter_var($ranking, FILTER_SANITIZE_NUMBER_INT) === false || $ranking == "" || !is_numeric($ranking) || $ranking < 0) {
		die("Invalid ranking ({$_GET["ranking"]})");
	}
}

if (isset($_GET["rankorder"])) {
	$rankorder = filter_var(trim($_GET["rankorder"]), FILTER_SANITIZE_NUMBER_INT);

	if (filter_var($rankorder, FILTER_SANITIZE_NUMBER_INT) === false || $rankorder == "" || !is_numeric($rankorder) || $rankorder < 0) {
		die("Invalid rankorder ({$_GET["rankorder"]})");
	}
}

$haserror = false;
$error_message = "";

$action = isset($_GET["action"]) ? $_GET["action"] : "";

if ($action == "insert" || $action == "update") {
	/* validate the data. */
	$title = filter_var(trim($_GET["title"], FILTER_SANITIZE_STRING));;
	$rendered = filter_var(trim($_GET["rendered"], FILTER_SANITIZE_STRING));;

	if ($title == "") {
		$haserror = true;
		$error_message = trim("$error_message A title is required.");
		$title_error = true;
	}
	if ($rendered == "") {
		$haserror = true;
		$error_message = trim("$error_message HTML is required.");
		$rendered_error = true;
	}
}

if ($action == "delete") {
	/* first, NULL all ranking FKs for items that use this rank. */
	$stmt = $smarty->dbh()->prepare("UPDATE {$opt["table_prefix"]}items SET ranking = NULL WHERE ranking = ?");
	$stmt->bindValue(1, (int) $ranking, PDO::PARAM_INT);
	$stmt->execute();

	$stmt = $smarty->dbh()->prepare("DELETE FROM {$opt["table_prefix"]}ranks WHERE ranking = ?");
	$stmt->bindValue(1, (int) $ranking, PDO::PARAM_INT);
	$stmt->execute();

	header("Location: " . getFullPath("ranks.php?message=Rank+deleted."));
	exit;
}
else if ($action == "promote") {
	$stmt = $smarty->dbh()->prepare("UPDATE {$opt["table_prefix"]}ranks SET rankorder = rankorder + 1 WHERE rankorder = ? - 1");
	$stmt->bindValue(1, (int) $rankorder, PDO::PARAM_INT);
	$stmt->execute();

	$stmt = $smarty->dbh()->prepare("UPDATE {$opt["table_prefix"]}ranks SET rankorder = rankorder - 1 WHERE ranking = ?");
	$stmt->bindValue(1, (int) $ranking, PDO::PARAM_INT);
	$stmt->execute();

	header("Location: " . getFullPath("ranks.php?message=Rank+promoted."));
	exit;
}
else if ($action == "demote") {
	$stmt = $smarty->dbh()->prepare("UPDATE {$opt["table_prefix"]}ranks SET rankorder = rankorder - 1 WHERE rankorder = ? + 1");
	$stmt->bindValue(1, (int) $rankorder, PDO::PARAM_INT);
	$stmt->execute();

	$stmt = $smarty->dbh()->prepare("UPDATE {$opt["table_prefix"]}ranks SET rankorder = rankorder + 1 WHERE ranking = ?");
	$stmt->bindValue(1, (int) $ranking, PDO::PARAM_INT);
	$stmt->execute();

	header("Location: " . getFullPath("ranks.php?message=Rank+demoted."));
	exit;
}
else if ($action == "edit") {
	$stmt = $smarty->dbh()->prepare("SELECT title, rendered FROM {$opt["table_prefix"]}ranks WHERE ranking = ?");
	$stmt->bindValue(1, (int) $ranking, PDO::PARAM_INT);
	$stmt->execute();
	if ($row = $stmt->fetch()) {
		$title = $row["title"];
		$rendered = $row["rendered"];
	}
}
else if ($action == "") {
	$title = "";
	$rendered = "";
}
else if ($action == "insert") {
	if (!$haserror) {
		/* we can't assume the DB has a sequence on this so determine the highest rankorder and add one. */
		$stmt = $smarty->dbh()->prepare("SELECT MAX(rankorder) as maxrankorder FROM {$opt["table_prefix"]}ranks");
		$stmt->execute();
		if ($row = $stmt->fetch()) {
			$rankorder = $row["maxrankorder"] + 1;
			$stmt = $smarty->dbh()->prepare("INSERT INTO {$opt["table_prefix"]}ranks(title,rendered,rankorder) VALUES(?, ?, ?)");
			$stmt->bindParam(1, $title, PDO::PARAM_STR);
			$stmt->bindParam(2, $rendered, PDO::PARAM_STR);
			$stmt->bindParam(3, $rankorder, PDO::PARAM_INT);
			$stmt->execute();

			header("Location: " . getFullPath("ranks.php?message=Rank+added."));
			exit;
		}
	}
}
else if ($action == "update") {
	if (!$haserror) {
		$stmt = $smarty->dbh()->prepare("UPDATE {$opt["table_prefix"]}ranks " .
					"SET title = ?, rendered = ? " .
					"WHERE ranking = ?");
		$stmt->bindParam(1, $title, PDO::PARAM_STR);
		$stmt->bindParam(2, $rendered, PDO::PARAM_STR);
		$stmt->bindValue(3, (int) $ranking, PDO::PARAM_INT);
		$stmt->execute();

		header("Location: " . getFullPath("ranks.php?message=Rank+updated."));
		exit;
	}
}
else {
	die("Unknown verb.");
}

$stmt = $smarty->dbh()->prepare("SELECT ranking, title, rendered, rankorder " .
			"FROM {$opt["table_prefix"]}ranks " .
			"ORDER BY rankorder");
$stmt->execute();
$ranks = array();
while ($row = $stmt->fetch()) {
	$ranks[] = $row;
}

$smarty->assign('action', $action);
$smarty->assign('ranks', $ranks);
if (isset($message)) {
	$smarty->assign('message', $message);
}
$smarty->assign('title', $title);
if (isset($title_error)) {
	$smarty->assign('title_error', $title_error);
}
$smarty->assign('rendered', $rendered);
if (isset($rendered_error)) {
	$smarty->assign('rendered_error', $rendered_error);
}
$smarty->assign('ranking', isset($ranking) ? (int) $ranking : "");
$smarty->assign('haserror', isset($haserror) ? $haserror : false);
if ($error_message != "") {
	$smarty->assign('error_message', $error_message);
}
$smarty->display('ranks.tpl');
?>
