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

if (!empty($_GET["message"])) {
	$message = filter_var(trim($_GET["message"], FILTER_SANITIZE_STRING));
	$message = htmlspecialchars($message, ENT_QUOTES, 'UTF-8');
}

if (isset($_REQUEST["username"])) {
	$username = filter_var(strtolower(trim($_REQUEST["username"])), FILTER_SANITIZE_STRING);
	$username = htmlspecialchars($username, ENT_QUOTES, 'UTF-8');
}
if (isset($_REQUEST["fullname"])) {
	$fullname = filter_var(trim($_REQUEST["fullname"]), FILTER_SANITIZE_STRING);
	$fullname = htmlspecialchars($fullname, ENT_QUOTES, 'UTF-8');
}
if (isset($_REQUEST["email"])) {
	$email = filter_var(trim($_REQUEST["email"]), FILTER_SANITIZE_EMAIL);
	$email = htmlspecialchars($email, ENT_QUOTES, 'UTF-8');
}
if (isset($_GET["familyid"])) {
	$familyid = filter_var(trim($_REQUEST["familyid"]), FILTER_SANITIZE_NUMBER_INT);

	if (filter_var($familyid, FILTER_SANITIZE_NUMBER_INT) === false || $familyid == "" || !is_numeric($familyid) || $familyid < 0) {
		die("Invalid familyid ({$_REQUEST["familyid"]})");
	}
}

$haserror = false;
$error_message = "";
if (!isset($username)) $username = "";
if (!isset($fullname)) $fullname = "";
if (!isset($email)) $email = "";
if (!isset($familyid)) $familyid = $opt['newuser_default_family'];

if (isset($_POST["action"]) && $_POST["action"] == "signup") {
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
	if (!$haserror) {
	// make sure that username isn't taken.
		$stmt = $smarty->dbh()->prepare("SELECT userid FROM {$opt["table_prefix"]}users WHERE username = ?");
		$stmt->bindParam(1, $username, PDO::PARAM_STR);
		$stmt->execute();
		if ($stmt->fetch()) {
			$error_message = trim("$error_message The username '" . $username . "' is already taken.  Please choose another.");
			$username_error = true;
		}
		else {
			// generate a password and insert the row.
			// NOTE: if approval is required, this password will be replaced
			// when the account is approved.
			$pwd = generatePassword($opt);

			$stmt = $smarty->dbh()->prepare("INSERT INTO {$opt["table_prefix"]}users(username,fullname,password,email,approved,initialfamilyid) VALUES(?, ?, {$opt["password_hasher"]}(?), ?, ?, ?)");
			$stmt->bindParam(1, $username, PDO::PARAM_STR);
			$stmt->bindParam(2, $fullname, PDO::PARAM_STR);
			$stmt->bindParam(3, $pwd, PDO::PARAM_STR);
			$stmt->bindParam(4, $email, PDO::PARAM_STR);
			$stmt->bindValue(5, !$opt["newuser_requires_approval"], PDO::PARAM_BOOL);
			$stmt->bindParam(6, $familyid, PDO::PARAM_INT);
			$stmt->execute();

			// fetch new user information
			$stmt = $smarty->dbh()->prepare("SELECT userid FROM {$opt["table_prefix"]}users WHERE username = ?");
			$stmt->bindParam(1, $username, PDO::PARAM_STR);
			$stmt->execute();
			if ($row = $stmt->fetch()) {
				$userid = $row["userid"];
			}
			if ($opt["newuser_requires_approval"]) {
				// send the e-mails to the administrators.
				$stmt = $smarty->dbh()->prepare("SELECT fullname, email FROM {$opt["table_prefix"]}users WHERE admin = 1 AND email IS NOT NULL");
				$stmt->execute();
				while ($row = $stmt->fetch()) {
					mail(
						$row["email"],
						"Gift Registry approval request for " . $fullname,
						$fullname . " <" . $email . "> would like you to approve him/her for access to the Gift Registry.\r\n" .
						"To approve, click: {$_SERVER['REQUEST_SCHEME']}://{$_SERVER['HTTP_HOST']}/admin.php?action=approve&userid=$userid&familyid=1\r\n" .
						"To reject, click: {$_SERVER['REQUEST_SCHEME']}://{$_SERVER['HTTP_HOST']}/admin.php?action=reject&userid=$userid'\r\n" .
							"If granting approval, make sure to put him/her in the appropriate family, if necessary",
						"From: {$opt["email_from"]}\r\nReply-To: {$opt["email_reply_to"]}\r\nX-Mailer: {$opt["email_xmailer"]}\r\n"
					) or die("Mail not accepted for " . $row["email"]);
				}
			}
			else {
				// we don't require approval,
				// so immediately send them their initial password.
				// also, join them up to their initial family (if requested).
				if ($familyid != NULL) {
					$stmt = $smarty->dbh()->prepare("SELECT userid FROM {$opt["table_prefix"]}users WHERE username = ?");
					$stmt->bindParam(1, $username, PDO::PARAM_STR);
					$stmt->execute();
					if ($row = $stmt->fetch()) {
						$userid = $row["userid"];

						$stmt = $smarty->dbh()->prepare("INSERT INTO {$opt["table_prefix"]}memberships(userid,familyid) VALUES(?, ?)");
						$stmt->bindParam(1, $userid, PDO::PARAM_INT);
						$stmt->bindParam(2, $familyid, PDO::PARAM_INT);
						$stmt->execute();
					}

					mail(
						$email,
						"Gift Registry account created",
						"Your Gift Registry account was created.\r\n" .
							"Your username is $username and your password is '$pwd'.\r\n" .
							"Log in to {$_SERVER['REQUEST_SCHEME']}://{$_SERVER['HTTP_HOST']}/ and change your password under " .
							"'Update Profile' as soon as possible:\r\n" .
							"   {$_SERVER['REQUEST_SCHEME']}://{$_SERVER['HTTP_HOST']}/profile.php\r\n" .
							"\r\n" .
							"There is help and a browser bookmarklet at {$_SERVER['REQUEST_SCHEME']}://{$_SERVER['HTTP_HOST']}/help.php\r\n" .
							"\r\n" .
							"Once you've logged in, you can see the people you can shop for under 'Available People To Shopping For'. " .
							"Click on the icon next to each person you want to shop for to see their lists.\r\n" .
							"\r\n" .
							"If you have any questions or problems, email {$opt['email_from']}.\r\n",
						"From: {$opt["email_from"]}\r\nReply-To: {$opt["email_reply_to"]}\r\nX-Mailer: {$opt["email_xmailer"]}\r\n"
					) or die("Mail not accepted for $email");
				}
			}
		}
	}
}

$stmt = $smarty->dbh()->prepare("SELECT familyid, familyname FROM {$opt["table_prefix"]}families ORDER BY familyname");
$stmt->execute();
$families = array();
while ($row = $stmt->fetch()) {
	$families[] = $row;
}

if (count($families) == 1) {
	// default the family to the single family we have.
	$familyid = $families[0]["familyid"];
}
if (isset($opt['newuser_default_family']) && $opt['newuser_default_family'] != 0) {
	$familyid = $opt['newuser_default_family'];
}
if ($haserror) {
	$smarty->assign('haserror', $haserror);
}
$smarty->assign('families', $families);
$smarty->assign('username', $username);
$smarty->assign('fullname', $fullname);
$smarty->assign('email', $email);
$smarty->assign('familyid', $familyid);
$smarty->assign('familycount', count($families));
if (isset($_POST["action"])) {
	$smarty->assign('action', $_POST["action"]);
}
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
if ($error_message != "") {
	$smarty->assign('error_message', $error_message);
}
$smarty->display('signup.tpl');
?>
