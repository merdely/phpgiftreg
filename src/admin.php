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
	header("Location: " . getFullPath("login.php") . "?from=admin.php");
	exit;
}
else if ($_SESSION["admin"] != 1) {
	echo "You don't have admin privileges.";
	exit;
}
else {
	$userid = $_SESSION["userid"];
}

if (isset($_GET["familyid"])) {
	$familyid = filter_var(trim($_GET["familyid"]), FILTER_SANITIZE_NUMBER_INT);

	if (filter_var($familyid, FILTER_SANITIZE_NUMBER_INT) === false || $familyid == "" || !is_numeric($familyid) || $familyid < 0) {
		die("Invalid familyid ({$_GET["familyid"]})");
	}
}

if (isset($_GET["userid"])) {
	$userid = filter_var(trim($_GET["userid"]), FILTER_SANITIZE_NUMBER_INT);

	if (filter_var($userid, FILTER_SANITIZE_NUMBER_INT) === false || $userid == "" || !is_numeric($userid) || $userid < 0) {
		die("Invalid userid ({$_GET["userid"]})");
	}
}

$action = $_GET["action"];
if ($action == "approve") {
	$pwd = generatePassword($opt);
	if ($familyid != "") {
		$stmt = $smarty->dbh()->prepare("INSERT INTO {$opt["table_prefix"]}memberships(userid,familyid) VALUES(?, ?)");
		$stmt->bindValue(1, (int) $userid, PDO::PARAM_INT);
		$stmt->bindValue(2, (int) $familyid, PDO::PARAM_INT);
		$stmt->execute();
	}
	$stmt = $smarty->dbh()->prepare("UPDATE {$opt["table_prefix"]}users SET approved = 1, password = {$opt["password_hasher"]}(?) WHERE userid = ?");
	$stmt->bindParam(1, $pwd, PDO::PARAM_STR);
	$stmt->bindValue(2, (int) $userid, PDO::PARAM_INT);
	$stmt->execute();

	// send the e-mails
	$stmt = $smarty->dbh()->prepare("SELECT username, email FROM {$opt["table_prefix"]}users WHERE userid = ?");
	$stmt->bindValue(1, (int) $userid, PDO::PARAM_INT);
	$stmt->execute();
	if ($row = $stmt->fetch()) {
		mail(
			$row["email"],
			"Gift Registry application approved",
			"Your Gift Registry application was approved.\r\n" .
				"Your username is {$row["username"]} and your password is '$pwd'.\r\n" .
					"Log in to {$_SERVER['REQUEST_SCHEME']}://{$_SERVER['HTTP_HOST']}/ and change your password under " .
					"'Update Profile' (menu at the top/right of the page) as soon as possible.\r\n" .
					"\r\n" .
					"There is a browser bookmarklet at {$_SERVER['REQUEST_SCHEME']}://{$_SERVER['HTTP_HOST']}/help.php\r\n" .
					"\r\n" .
					"Once you've logged in, you can see the people you can shop for under 'Available People To Shopping For'. " .
					"Click on the icon next to each person you want to shop for to see their lists.\r\n" .
					"\r\n" .
					"If you have any questions or problems, email {$opt['email_from']}.\r\n",
			"From: {$opt["email_from"]}\r\nReply-To: {$opt["email_reply_to"]}\r\nX-Mailer: {$opt["email_xmailer"]}\r\n"
		) or die("Mail not accepted for " . $row["email"]);
	}
	header("Location: " . getFullPath("families.php"));
	exit;
}
else if ($action == "reject") {
	// send the e-mails
	$stmt = $smarty->dbh()->prepare("SELECT email FROM {$opt["table_prefix"]}users WHERE userid = ?");
	$stmt->bindValue(1, (int) $userid, PDO::PARAM_INT);
	$stmt->execute();
	if ($row = $stmt->fetch()) {
		mail(
			$row["email"],
			"Gift Registry application denied",
			"Your Gift Registry application was denied.",
			"From: {$opt["email_from"]}\r\nReply-To: {$opt["email_reply_to"]}\r\nX-Mailer: {$opt["email_xmailer"]}\r\n"
		) or die("Mail not accepted for " . $row["email"]);
	}

	$stmt = $smarty->dbh()->prepare("DELETE FROM {$opt["table_prefix"]}users WHERE userid = ?");
	$stmt->bindValue(1, (int) $userid, PDO::PARAM_INT);
	$stmt->execute();

	header("Location: " . getFullPath("index.php"));
	exit;
}
?>
