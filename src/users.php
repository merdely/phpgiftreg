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
	header("Location: " . getFullPath("login.php") . "?from=users.php");
	exit;
}
else {
	$userid = $_SESSION["userid"];
}

if ($_SESSION["admin"] != 1) {
	echo "You don't have admin privileges.";
	exit;
}

if (!empty($_GET["message"])) {
	$message = filter_var(trim($_GET["message"], FILTER_SANITIZE_STRING));;
	$message = htmlspecialchars($message, ENT_QUOTES, 'UTF-8');
}

if (isset($_GET["userid"])) {
	$userid = filter_var(trim($_GET["userid"]), FILTER_SANITIZE_NUMBER_INT);

	if (filter_var($userid, FILTER_SANITIZE_NUMBER_INT) === false || $userid == "" || !is_numeric($userid) || $userid < 0) {
		die("Invalid userid ({$_GET["userid"]})");
	}
}

$haserror = false;
$error_message = "";

if (isset($_GET["email"])) {
	$email = filter_var(trim($_GET["email"], FILTER_SANITIZE_EMAIL));;
	$email = htmlspecialchars($email, ENT_QUOTES, 'UTF-8');
}

if (isset($_GET["action"]))
	$action = $_GET["action"];
else
	$action = "";

if ($action == "insert" || $action == "update") {
	/* validate the data. */
	$username = filter_var(trim($_GET["username"], FILTER_SANITIZE_STRING));;
	$username = htmlspecialchars($username, ENT_QUOTES, 'UTF-8');
	$fullname = filter_var(trim($_GET["fullname"], FILTER_SANITIZE_STRING));;
	$fullname = htmlspecialchars($fullname, ENT_QUOTES, 'UTF-8');
	if (isset($_GET["email_msgs"]))
		$email_msgs = (strtoupper($_GET["email_msgs"]) == "ON" ? 1 : 0);
	else
		$email_msgs = 0;
	if (isset($_GET["show_helptext"]))
		$show_helptext = (strtoupper($_GET["show_helptext"]) == "ON" ? 1 : 0);
	else
		$show_helptext = 0;
	if (isset($_GET["approved"]))
		$approved = (strtoupper($_GET["approved"]) == "ON" ? 1 : 0);
	else
		$approved = 0;
	if (isset($_GET["admin"]))
		$userisadmin = (strtoupper($_GET["admin"]) == "ON" ? 1 : 0);
	else
		$userisadmin = 0;

	if ($username == "") {
		$haserror = true;
		$error_message = trim("$error_message A username is required.");
		$username_error = true;
	}
	if ($fullname == "") {
		$haserror = true;
		$error_message = trim("$error_message A full name is required.");
		$fullname_error = true;
	}
	if ($email == "") {
		$haserror = true;
		$error_message = trim("$error_message An e-mail address is required.");
		$email_error = true;
	} elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
		$haserror = true;
		$error_message = trim("$error_message Invalid e-mail address.");
		$email_error = true;
	}
}

if ($action == "delete") {
	// MySQL is too l4m3 to have cascade deletes, so we'll have to do the
	// work ourselves.
	$deluserid = (int) $userid;

	$stmt = $smarty->dbh()->prepare("DELETE FROM {$opt["table_prefix"]}shoppers WHERE shopper = ? OR mayshopfor = ?");
	$stmt->bindParam(1, $deluserid, PDO::PARAM_INT);
	$stmt->bindParam(2, $deluserid, PDO::PARAM_INT);
	$stmt->execute();

	// we can't leave messages with dangling senders, so delete those too.
	$stmt = $smarty->dbh()->prepare("DELETE FROM {$opt["table_prefix"]}messages WHERE sender = ? OR recipient = ?");
	$stmt->bindParam(1, $deluserid, PDO::PARAM_INT);
	$stmt->bindParam(2, $deluserid, PDO::PARAM_INT);
	$stmt->execute();

	$stmt = $smarty->dbh()->prepare("DELETE FROM {$opt["table_prefix"]}events WHERE userid = ?");
	$stmt->bindParam(1, $deluserid, PDO::PARAM_INT);
	$stmt->execute();

	$stmt = $smarty->dbh()->prepare("DELETE FROM {$opt["table_prefix"]}items WHERE userid = ?");
	$stmt->bindParam(1, $deluserid, PDO::PARAM_INT);
	$stmt->execute();

	$stmt = $smarty->dbh()->prepare("DELETE FROM {$opt["table_prefix"]}users WHERE userid = ?");
	$stmt->bindParam(1, $deluserid, PDO::PARAM_INT);
	$stmt->execute();

	header("Location: " . getFullPath("users.php?message=User+deleted."));
	exit;
}
else if ($action == "edit") {
	$stmt = $smarty->dbh()->prepare("SELECT username, fullname, email, email_msgs, show_helptext, approved, admin FROM {$opt["table_prefix"]}users WHERE userid = ?");
	$stmt->bindValue(1, (int) $userid, PDO::PARAM_INT);
	$stmt->execute();
	if ($row = $stmt->fetch()) {
		$username = $row["username"];
		$fullname = $row["fullname"];
		$email = $row["email"];
		$email_msgs = $row["email_msgs"];
		$show_helptext = $row["show_helptext"];
		$approved = $row["approved"];
		$userisadmin = $row["admin"];
	}
}
else if ($action == "") {
	$username = "";
	$fullname = "";
	$email = "";
	$email_msgs = 1;
	$show_helptext = 1;
	$approved = 1;
	$userisadmin = 0;
}
else if ($action == "insert") {
	if (!$haserror) {
		// generate a password and insert the row.
		$pwd = generatePassword($opt);
		$stmt = $smarty->dbh()->prepare("INSERT INTO {$opt["table_prefix"]}users(username,password,fullname,email,email_msgs,show_helptext,approved,admin) VALUES(?, {$opt["password_hasher"]}(?), ?, ?, ?, ?, ?)");
		$stmt->bindParam(1, $username, PDO::PARAM_STR);
		$stmt->bindParam(2, $pwd, PDO::PARAM_STR);
		$stmt->bindParam(3, $fullname, PDO::PARAM_STR);
		$stmt->bindParam(4, $email, PDO::PARAM_STR);
		$stmt->bindParam(5, $email_msgs, PDO::PARAM_BOOL);
		$stmt->bindParam(6, $show_helptext, PDO::PARAM_BOOL);
		$stmt->bindParam(7, $approved, PDO::PARAM_BOOL);
		$stmt->bindParam(8, $userisadmin, PDO::PARAM_BOOL);
		$stmt->execute();

		mail(
			$email,
			"Gift Registry account created",
			"Your Gift Registry account was created.\r\n" .
				"Your username is $username and your password is '$pwd'.\r\n" .
				"Log in to {$_SERVER['REQUEST_SCHEME']}://{$_SERVER['HTTP_HOST']}/ and change your password under\r\n" .
				"Update Profile (menu at the top/right of the page) as soon as possible.\r\n" .
				"\r\n" .
				"There is a browser bookmarklet at {$_SERVER['REQUEST_SCHEME']}://{$_SERVER['HTTP_HOST']}/help.php\r\n" .
				"\r\n" .
				"Once you've logged in, you can see the people you can shop for under 'Available People To Shopping For'. " .
				"Click on the icon next to each person you want to shop for to see their lists.\r\n" .
				"\r\n" .
				"If you have any questions or problems, email {$opt['email_from']}.\r\n",
			"From: {$opt["email_from"]}\r\nReply-To: {$opt["email_reply_to"]}\r\nX-Mailer: {$opt["email_xmailer"]}\r\n"
		) or die("Mail not accepted for $email");
		header("Location: " . getFullPath("users.php?message=User+added+and+e-mail+sent."));
		exit;
	}
}
else if ($action == "update") {
	if (!$haserror) {
		$stmt = $smarty->dbh()->prepare("UPDATE {$opt["table_prefix"]}users SET " .
				"username = ?, " .
				"fullname = ?, " .
				"email = ?, " .
				"email_msgs = ?, " .
				"show_helptext = ?, " .
				"approved = ?, " .
				"admin = ? " .
				"WHERE userid = ?");
		$stmt->bindParam(1, $username, PDO::PARAM_STR);
		$stmt->bindParam(2, $fullname, PDO::PARAM_STR);
		$stmt->bindParam(3, $email, PDO::PARAM_STR);
		$stmt->bindParam(4, $email_msgs, PDO::PARAM_BOOL);
		$stmt->bindParam(5, $show_helptext, PDO::PARAM_BOOL);
		$stmt->bindParam(6, $approved, PDO::PARAM_BOOL);
		$stmt->bindParam(7, $userisadmin, PDO::PARAM_BOOL);
		$stmt->bindValue(8, (int) $userid, PDO::PARAM_INT);
		$stmt->execute();
		header("Location: " . getFullPath("users.php?message=User+updated."));
		exit;
	}
}
else if ($action == "reset") {
	$resetuserid = (int) $userid;
	$resetemail = $email;

	// generate a password and insert the row.
	$pwd = generatePassword($opt);
	$stmt = $smarty->dbh()->prepare("UPDATE {$opt["table_prefix"]}users SET password = {$opt["password_hasher"]}(?) WHERE userid = ?");
	$stmt->bindParam(1, $pwd, PDO::PARAM_STR);
	$stmt->bindParam(2, $resetuserid, PDO::PARAM_INT);
	$stmt->execute();
	mail(
		$resetemail,
		"Gift Registry password reset",
		"Your Gift Registry password was reset to '$pwd'.\r\n" .
		"Log in to {$_SERVER['REQUEST_SCHEME']}://{$_SERVER['HTTP_HOST']}/ and change your password under\r\n" .
		"Update Profile (menu at the top/right of the page) as soon as possible.",
		"From: {$opt["email_from"]}\r\nReply-To: {$opt["email_reply_to"]}\r\nX-Mailer: {$opt["email_xmailer"]}\r\n"
	) or die("Mail not accepted for $email");
	header("Location: " . getFullPath("users.php?message=Password+reset."));
	exit;
}
else {
	echo "Unknown verb.";
	exit;
}

$stmt = $smarty->dbh()->prepare("SELECT userid, username, fullname, email, email_msgs, show_helptext, approved, admin FROM {$opt["table_prefix"]}users ORDER BY username");
$stmt->execute();
$users = array();
while ($row = $stmt->fetch()) {
	$users[] = $row;
}

$smarty->assign('action', $action);
$smarty->assign('edituserid', isset($userid) ? (int) $userid : -1);
$smarty->assign('username', $username);
if (isset($username_error)) {
	$smarty->assign('username_error', $username_error);
}
$smarty->assign('fullname', $fullname);
if (isset($fullname_error)) {
	$smarty->assign('fullname_error', $fullname_error);
}
$smarty->assign('email', $email);
if (isset($email_error)) {
	$smarty->assign('email_error', $email_error);
}
$smarty->assign('email_msgs', $email_msgs);
$smarty->assign('show_helptext', $show_helptext);
$smarty->assign('approved', $approved);
$smarty->assign('userisadmin', $userisadmin);
if ($haserror) {
	$smarty->assign('haserror', $haserror);
}
if ($error_message != "") {
	$smarty->assign('error_message', $error_message);
}
$smarty->assign('users', $users);
if (isset($message)) {
	$smarty->assign('message', $message);
}
$smarty->assign('userid', $userid);
$smarty->display('users.tpl');
?>
