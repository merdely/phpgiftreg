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
	header("Location: " . getFullPath("login.php") . "?from=shop.php");
	exit;
}
else {
	$userid = $_SESSION["userid"];
}

$opt['show_helptext'] = $_SESSION['show_helptext'];

if (isset($_GET["shopfor"])) {
	$shopfor = filter_var(trim($_GET["shopfor"]), FILTER_SANITIZE_NUMBER_INT);

	if (filter_var($shopfor, FILTER_SANITIZE_NUMBER_INT) === false || $shopfor == "" || !is_numeric($shopfor) || $shopfor < 0) {
		die("Invalid shopfor ({$_GET["shopfor"]})");
	}
	$shopfor = (int) $shopfor;
//} else {
//	header("Location: " . getFullPath("index.php"));
}

if ($shopfor == $userid) {
	echo "Nice try! (You can't shop for yourself.)";
	exit;
}
$action = "";
if (!empty($_GET["action"])) {
	$action = $_GET["action"];
	if (isset($_GET["itemid"])) {
		$itemid = filter_var(trim($_GET["itemid"]), FILTER_SANITIZE_NUMBER_INT);

		if (filter_var($itemid, FILTER_SANITIZE_NUMBER_INT) === false || $itemid == "" || !is_numeric($itemid) || $itemid < 0) {
			die("Invalid itemid ({$_GET["itemid"]})");
		}
		$itemid = (int) $itemid;
	}
	$stmt = $smarty->dbh()->prepare("SELECT items.name, users.fullname FROM {$opt["table_prefix"]}items JOIN {$opt["table_prefix"]}users ON items.userid = users.userid WHERE items.itemid = ?");
	$stmt->bindParam(1, $itemid, PDO::PARAM_INT);
	$stmt->execute();
	if ($row = $stmt->fetch()) {
		$name = $row["name"];
		$fullname = $row["fullname"];
	}
	if ($action == "reserve") {
		adjustAllocQuantity($itemid,$userid,0,+1, $smarty->dbh(), $smarty->opt());
		header("Location: " . getFullPath("shop.php?shopfor=$shopfor&message='$name'+reserved+for+$fullname"));
	}
	else if ($action == "purchase") {
		// decrement reserved.
		adjustAllocQuantity($itemid,$userid,0,-1, $smarty->dbh(), $smarty->opt());
		// increment purchased.
		adjustAllocQuantity($itemid,$userid,1,+1, $smarty->dbh(), $smarty->opt());
		header("Location: " . getFullPath("shop.php?shopfor=$shopfor&message='$name'+purchased+for+$fullname"));
	}
	else if ($action == "return") {
		// increment reserved.
		adjustAllocQuantity($itemid,$userid,0,+1, $smarty->dbh(), $smarty->opt());
		// decrement purchased.
		adjustAllocQuantity($itemid,$userid,1,-1, $smarty->dbh(), $smarty->opt());
		header("Location: " . getFullPath("shop.php?shopfor=$shopfor&message='$name'+returned+for+$fullname"));
	}
	else if ($action == "release") {
		adjustAllocQuantity($itemid,$userid,0,-1, $smarty->dbh(), $smarty->opt());
		header("Location: " . getFullPath("shop.php?shopfor=$shopfor&message='$name'+released+for+$fullname"));
	}
	else if ($action == "copy") {
		/*
		can't do this because MySQL 3.x doesn't seem to support it (at least the version i was using).
		$query = "INSERT INTO items(userid,description,price,source,url,category) SELECT $userid, description, price, source, url, category FROM items WHERE itemid = " . $_GET["itemid"];
		*/
		$stmt = $smarty->dbh()->prepare("SELECT userid, name, description, price, source, url, category, comment, ranking, quantity, image_filename FROM {$opt["table_prefix"]}items WHERE itemid = ?");
		$stmt->bindParam(1, $itemid, PDO::PARAM_INT);
		$stmt->execute();
		if ($row = $stmt->fetch()) {
			$name = $row["name"];
			$desc = $row["description"];
			$source = $row["source"];
			$url = $row["url"];
			$comment = $row["comment"];
			$price = (float) $row["price"];
			$cat = (int) $row["category"];
			$quantity = (int) $row["quantity"];
			$image_filename = $row["image_filename"];

			// Copy the image
			// what's the extension?
			$parts = pathinfo($image_filename);
			$file_ext = $parts['extension'];
			// what is full path to store images?  get it from the currently executing script.
			$parts = pathinfo($_SERVER["SCRIPT_FILENAME"]);
			$upload_dir = $parts['dirname'];
			// generate a temporary file in the configured directory.
			$temp_name = tempnam($upload_dir . "/" . $opt["image_subdir"],"");
			// unlink it, we really want an extension on that.
			unlink($temp_name);
			// here's the name we really want to use.  full path is included.
			$new_image_filename = $temp_name . "." . $file_ext;
			// copy the original file
			copy($upload_dir . "/" . $opt["image_subdir"] . "/" . $image_filename, $new_image_filename);
			// fix permissions on the new file
			chmod($new_image_filename, 0644);
			// the name we're going to record in the DB is the filename without the path.
			$image_base_filename = basename($new_image_filename);

			$stmt = $smarty->dbh()->prepare("INSERT INTO {$opt["table_prefix"]}items(userid,name,description,price,source,url,comment,category,ranking,quantity,image_filename) VALUES(?, ?, ?, ?, ?, ?, ?, 1, 3, ?, ?)");
			$stmt->bindParam(1, $userid, PDO::PARAM_INT);
			$stmt->bindParam(2, $name, PDO::PARAM_STR);
			$stmt->bindParam(3, $desc, PDO::PARAM_STR);
			$stmt->bindParam(4, $price);
			$stmt->bindParam(5, $source, PDO::PARAM_STR);
			$stmt->bindParam(6, $url, PDO::PARAM_STR);
			$stmt->bindParam(7, $comment, PDO::PARAM_STR);
			$stmt->bindParam(8, $quantity, PDO::PARAM_INT);
			$stmt->bindParam(9, $image_base_filename, PDO::PARAM_STR);
			$stmt->execute();

			stampUser($userid, $smarty->dbh(), $smarty->opt());

			$message = "Added '" . $name . "' to your gift list.";
		}
	}
}

$stmt = $smarty->dbh()->prepare("SELECT * FROM {$opt["table_prefix"]}shoppers WHERE shopper = ? AND mayshopfor = ? AND pending = 0");
$stmt->bindParam(1, $userid, PDO::PARAM_INT);
$stmt->bindParam(2, $shopfor, PDO::PARAM_INT);
$stmt->execute();
if (!($stmt->fetch())) {
	echo "Nice try! (You can't shop for someone who hasn't approved it.)";
	exit;
}

if (!empty($_GET["sortdir"])) {
	$sortdir = strtoupper(trim($_GET["sortdir"])) == "DESC" ? "DESC" : "ASC";
} else {
	$sortdir = "ASC";
}
if (!isset($_GET["sort"])) {
	$sortby = "rankorder, name";
	$sort = "ranking";
}
else {
	$sort = filter_var(trim($_GET["sort"], FILTER_SANITIZE_STRING));;
	$sort = htmlspecialchars($sort, ENT_QUOTES, 'UTF-8');
	switch ($sort) {
		case "name":
			$sortby = "name $sortdir";
			$sort = "name";
			break;
		case "source":
			$sortby = "source $sortdir, rankorder, name";
			$sort = "source";
			break;
		case "price":
			$sortby = "price $sortdir, rankorder, name";
			$sort = "price";
			break;
		case "status":
			$sortby = "reservedid $sortdir, boughtid DESC, rankorder, name";
			$sort = "status";
			break;
		case "category":
			$sortby = "c.category $sortdir, rankorder, name";
			$sort = "category";
			break;
		default:
			$sortby = "rankorder $sortdir, name";
			$sort = "ranking";
	}
}

/* here's what we're going to do: we're going to pull back the shopping list along with any alloc record
	for those items with a quantity of 1.  if the item's quantity > 1 we'll query alloc when we
	get to that record.  the theory is that most items will have quantity = 1 so we'll make the least
	number of trips. */
$stmt = $smarty->dbh()->prepare("SELECT i.itemid, name, description, price, price as pricenum, source, i.category as catid, c.category, url, r.title as rank, i.ranking as rankid, image_filename, " .
		"ub.fullname AS bfullname, ub.userid AS boughtid, " .
		"ur.fullname AS rfullname, ur.userid AS reservedid, " .
		"rendered, i.comment, i.quantity " .
	"FROM {$opt["table_prefix"]}items i " .
	"LEFT OUTER JOIN {$opt["table_prefix"]}categories c ON c.categoryid = i.category " .
	"LEFT OUTER JOIN {$opt["table_prefix"]}ranks r ON r.ranking = i.ranking " .
	"LEFT OUTER JOIN {$opt["table_prefix"]}allocs a ON a.itemid = i.itemid AND i.quantity = 1 " .	// only join allocs for single-quantity items.
	"LEFT OUTER JOIN {$opt["table_prefix"]}users ub ON ub.userid = a.userid AND a.bought = 1 " .
	"LEFT OUTER JOIN {$opt["table_prefix"]}users ur ON ur.userid = a.userid AND a.bought = 0 " .
	"WHERE i.userid = ? " .
	"ORDER BY " . $sortby);
$stmt->bindParam(1, $shopfor, PDO::PARAM_INT);
$stmt->execute();
$shoprows = array();
while ($row = $stmt->fetch()) {
	$row['price'] = formatPrice($row['price'], $opt);
	if ($row['quantity'] > 1) {
		// check the allocs table to see what has been allocated.
		$avail = $row['quantity'];
		$substmt = $smarty->dbh()->prepare("SELECT a.quantity, a.bought, a.userid, " .
					"ub.fullname AS bfullname, ub.userid AS boughtid, " .
					"ur.fullname AS rfullname, ur.userid AS reservedid " .
				"FROM {$opt["table_prefix"]}allocs a " .
				"LEFT OUTER JOIN {$opt["table_prefix"]}users ub ON ub.userid = a.userid AND a.bought = 1 " .
				"LEFT OUTER JOIN {$opt["table_prefix"]}users ur ON ur.userid = a.userid AND a.bought = 0 " .
				"WHERE a.itemid = ? " .
				"ORDER BY a.bought, a.quantity");
		$substmt->bindValue(1, $row['itemid'], PDO::PARAM_INT);
		$substmt->execute();
		$ibought = 0;
		$ireserved = 0;
		$itemallocs = array();
		while ($allocrow = $substmt->fetch()) {
			if ($allocrow['bfullname'] != '') {
				if ($allocrow['boughtid'] == $userid) {
					$ibought += $allocrow['quantity'];
					$itemallocs[] = ($allocrow['quantity'] . " bought by you.");
				}
				else {
					if (!$opt["anonymous_purchasing"]) {
						$itemallocs[] = ($allocrow['quantity'] . " bought by " . $allocrow['bfullname'] . ".");
					}
					else {
						$itemallocs[] = ($allocrow['quantity'] . " bought.");
					}
				}
			}
			else {
				if ($allocrow['reservedid'] == $userid) {
					$ireserved += $allocrow['quantity'];
					$itemallocs[] = ($allocrow['quantity'] . " reserved by you.");
				}
				else {
					if (!$opt["anonymous_purchasing"]) {
						$itemallocs[] = ($allocrow['quantity'] . " reserved by " . $allocrow['rfullname'] . ".");
					}
					else {
						$itemallocs[] = ($allocrow['quanitity'] . " reserved.");
					}
				}
			}
			$avail -= $allocrow['quantity'];
		}
		$row['allocs'] = $itemallocs;
		$row['avail'] = $avail;
		$row['ibought'] = $ibought;
		$row['ireserved'] = $ireserved;
	}
	$row['urlhost'] = preg_replace("/^(https?:\/\/)?(www\.)?([^\/]+)(\/.*)?$/", "$3", $row['url']);
	$shoprows[] = $row;
}

/* okay, I *would* retrieve the shoppee's fullname from the items recordset,
	except that I wouldn't get it if he had no items, so I *could* LEFT OUTER
	JOIN, but then it would complicate the iteration logic, so let's just
	hit the DB again. */
$stmt = $smarty->dbh()->prepare("SELECT fullname, email, comment FROM {$opt["table_prefix"]}users WHERE userid = ?");
$stmt->bindParam(1, $shopfor, PDO::PARAM_INT);
$stmt->execute();
if ($row = $stmt->fetch()) {
	$ufullname = $row["fullname"];
	$ucomment = $row["comment"];
	$uemail = $row["email"];
}

$smarty->assign('sort', $sort);
$smarty->assign('sortdir', $sortdir);
$smarty->assign('ufullname', $ufullname);
$smarty->assign('uemail', $uemail);
$smarty->assign('ucomment', $ucomment);
$smarty->assign('shopfor', $shopfor);
$smarty->assign('shoprows', $shoprows);
$smarty->assign('userid', $userid);
if (isset($_GET["message"])) {
	$message = $_GET["message"];
}
if (isset($message)) {
	$smarty->assign('message', $message);
}
$smarty->display('shop.tpl');
?>
