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
	header("Location: " . getFullPath("login.php"));
	exit;
}
else {
	$userid = $_SESSION["userid"];
}

// for security, let's make sure that if an itemid was passed in, it belongs
// to $userid.  all operations on this page should only be performed by
// the item's owner.
if (isset($_REQUEST["itemid"]) && $_REQUEST["itemid"] != "") {
	try {
		$stmt = $smarty->dbh()->prepare("SELECT * FROM {$opt["table_prefix"]}items WHERE userid = ? AND itemid = ?");
		$stmt->bindParam(1, $userid, PDO::PARAM_INT);
		$stmt->bindValue(2, (int) $_REQUEST["itemid"], PDO::PARAM_INT);
		$stmt->execute();
		if (!$stmt->fetch()) {
			die("Nice try! (That's not your item.)");
		}
	}
	catch (PDOException $e) {
		die("sql exception: " . $e->getMessage());
	}
}

$action = "";
if (!empty($_REQUEST["action"])) {
	$action = $_REQUEST["action"];
	
	if ($action == "insert" || $action == "update") {
		/* validate the data. */
		$name = trim($_REQUEST["name"]);
		$bookmarklet = isset($_REQUEST["bookmarklet"]) ? trim($_REQUEST["bookmarklet"]) : "";
		$image_url = isset($_REQUEST["image_url"]) ? trim($_REQUEST["image_url"]) : "";
		$description = isset($_REQUEST["description"]) ? trim($_REQUEST["description"]) : "";
		$price = isset($_REQUEST["price"]) ? str_replace(",","",trim($_REQUEST["price"])) : "0";
		$source = isset($_REQUEST["source"]) ? trim($_REQUEST["source"]) : "";
		$url = isset($_REQUEST["url"]) ? trim($_REQUEST["url"]) : "";
		$category = isset($_REQUEST["category"]) ? trim($_REQUEST["category"]) : "1";
		$ranking = isset($_REQUEST["ranking"]) ? $_REQUEST["ranking"] : "3";
		$comment = isset($_REQUEST["comment"]) ? $_REQUEST["comment"] : "";
		$quantity = isset($_REQUEST["quantity"]) ? (int) $_REQUEST["quantity"] : 1;

		$haserror = false;
		if ($name == "") {
			$haserror = true;
			$name_error = "A name is required.";
		}
		if ($image_url != "" && preg_match("/^http(s)?:\/\/([^\/]+)/i",$image_url)) {
			$image_file_data = file_get_contents($image_url);
			if ($image_file_data !== false) {
				$temp_image = tempnam("/tmp","");
				file_put_contents($temp_image, $image_file_data);
                error_log("MWE: temp_image: $temp_image");
				$fh = fopen($temp_image, 'rb');
				if ($fh) {
					$header = fread($fh, 8);
					fclose($fh);
					$ext = "";
					if (bin2hex(substr($header, 0, 8)) === '89504e470d0a1a0a') {
						$ext = 'png';
					} elseif (bin2hex(substr($header, 0, 2)) === 'ffd8') {
						$ext = 'jpg';
					} elseif (in_array(bin2hex(substr($header, 0, 6)), ['474946383761', '474946383961'])) {
						$ext = 'gif';
					} elseif (bin2hex(substr($header, 0, 2)) === '424d') {
						$ext = 'bmp';
					} elseif (in_array(bin2hex(substr($header, 0, 4)), ['49492a00', '4d4d002a'])) {
						$ext = 'tiff';
					} elseif (bin2hex(substr($header, 0, 12)) === '524946462a00000057454250') {
						$ext = 'webp';
					}
				}
                error_log("MWE: ext: $ext");
				if ($ext != "") {
					$parts = pathinfo($_SERVER["SCRIPT_FILENAME"]);
					$upload_dir = $parts['dirname'];
					// generate a temporary file in the configured directory.
					$temp_name = tempnam($upload_dir . "/" . $opt["image_subdir"],"");
					// unlink it, we really want an extension on that.
					unlink($temp_name);
					// here's the name we really want to use.  full path is included.
					$image_filename = $temp_name . "." . $ext;
                    error_log("MWE: image_filename: $image_filename");
					// move the PHP temporary file to that filename.
					rename($temp_image, $image_filename);
					// fix permissions on the new file
					chmod($image_filename, 0644);
					// the name we're going to record in the DB is the filename without the path.
					$image_base_filename = basename($image_filename);
                    error_log("MWE: image_base_filename: $image_base_filename");
				}
			}
		}
		if ($bookmarklet == "1") {
			if ($source == "" && preg_match("/^Amazon.com:/", $name)) {
				$source = "Amazon";
			}
			if ($source == "" && $url != "") {
				$source = preg_replace("/^(https?:\/\/)?([^\/]+)(\/.*)?$/", "$2", $url);
			}
			$name = preg_replace("/^Amazon.com: /", "", $name);
			$name = preg_replace("/ : [A-Za-z0-9 &_,-]+/", "", $name);
		}
		if (strlen($name) > 100 && $description == "") {
			$description = $name;
		}
		if (strlen($name) > 100) {
			$name = substr($name, 0, 100);
		}
		if ($price == "" || !preg_match("/^\d*(\.\d{2})?$/i",$price)) {
			$price = 0;
		}
		if ($url != "" && !preg_match("/^http(s)?:\/\/([^\/]+)/i",$url)) {
			$haserror = true;
			$url_error = "A well-formed URL is required in the format <i>http://www.somesite.net/somedir/somefile.html</i>.";
		}
		if ($category == "") {
			$category = 1;
		}
		if ($ranking == "") {
			$ranking = 3;
		}
		if ($quantity == "" || (int) $quantity < 1) {
			$quantity = 1;
		}
	}

	if (!isset($image_url) && isset($haserror) && !$haserror && isset($_REQUEST["image"])) {
		if ($_REQUEST["image"] == "remove" || $_REQUEST["image"] == "replace") {
			deleteImageForItem((int) $_REQUEST["itemid"], $smarty->dbh(), $smarty->opt());
		}
		if ($_REQUEST["image"] == "upload" || $_REQUEST["image"] == "replace") {
			/* TODO: verify that it's an image using $_FILES["imagefile"]["type"] */
			// what's the extension?
			$parts = pathinfo($_FILES["imagefile"]["name"]);
			$uploaded_file_ext = $parts['extension'];
			// what is full path to store images?  get it from the currently executing script.
			$parts = pathinfo($_SERVER["SCRIPT_FILENAME"]);
			$upload_dir = $parts['dirname'];
			// generate a temporary file in the configured directory.
			$temp_name = tempnam($upload_dir . "/" . $opt["image_subdir"],"");
			// unlink it, we really want an extension on that.
			unlink($temp_name);
			// here's the name we really want to use.  full path is included.
			$image_filename = $temp_name . "." . $uploaded_file_ext;
			// move the PHP temporary file to that filename.
			move_uploaded_file($_FILES["imagefile"]["tmp_name"],$image_filename);
			// fix permissions on the new file
			chmod($image_filename, 0644);
			// the name we're going to record in the DB is the filename without the path.
			$image_base_filename = basename($image_filename);
		}
	}
	
	if ($action == "delete") {
		try {
			/* find out if this item is bought or reserved. */
			$stmt = $smarty->dbh()->prepare("SELECT a.userid, a.quantity, a.bought, i.name, i.description FROM {$opt["table_prefix"]}allocs a LEFT OUTER JOIN {$opt["table_prefix"]}items i ON i.itemid = a.itemid WHERE a.itemid = ?");
			$stmt->bindValue(1, (int) $_REQUEST["itemid"], PDO::PARAM_INT);
			$stmt->execute();
			$name = ""; // need this outside of the while block.
			while ($row = $stmt->fetch()) {
				$buyerid = $row["userid"];
				$quantity = $row["quantity"];
				$bought = $row["bought"];
				$name = $row["name"];	// need this for descriptions.
				$description = $row["description"];	// need this for descriptions.
				if ($buyerid != null) {
					sendMessage($userid,
						$buyerid,
						"$name that you " . (($bought == 1) ? "bought" : "reserved") . " $quantity of for {$_SESSION["fullname"]} has been deleted.  Check your reservation/purchase to ensure it's still needed.",
						$smarty->dbh(),
						$smarty->opt());
				}
			}
	
			deleteImageForItem((int) $_REQUEST["itemid"], $smarty->dbh(), $smarty->opt());

			$stmt = $smarty->dbh()->prepare("DELETE FROM {$opt["table_prefix"]}items WHERE itemid = ?");
			$stmt->bindValue(1, (int) $_REQUEST["itemid"], PDO::PARAM_INT);
			$stmt->execute();

			// TODO: are we leaking allocs records here?
		
			stampUser($userid, $smarty->dbh(), $smarty->opt());
			processSubscriptions($userid, $action, $name, $smarty->dbh(), $smarty->opt());

			header("Location: " . getFullPath("index.php?message=Item+deleted."));
			exit;
		}
		catch (PDOException $e) {
			die("sql exception: " . $e->getMessage());
		}
	}
	else if ($action == "edit") {
		$stmt = $smarty->dbh()->prepare("SELECT name, description, price, source, category, url, ranking, comment, quantity, image_filename FROM {$opt["table_prefix"]}items WHERE itemid = ?");
		$stmt->bindValue(1, (int) $_REQUEST["itemid"], PDO::PARAM_INT);
		$stmt->execute();

		if ($row = $stmt->fetch()) {
			$name = $row["name"];
			$description = $row["description"];
			$price = number_format($row["price"],2,".",",");
			$source = $row["source"];
			$url = $row["url"];
			$category = $row["category"];
			$ranking = $row["ranking"];
			$comment = $row["comment"];
			$quantity = (int) $row["quantity"];
			$image_filename = $row["image_filename"];
		}
	}
	else if ($action == "add") {
		$name = "";
		$description = "";
		$price = 0.00;
		$source = "";
		$url = "";
		$category = 1;
		$ranking = 3;
		$comment = "";
		$quantity = 1;
		$image_filename = "";
	}
	else if ($action == "insert") {
		if (!$haserror) {
			$stmt = $smarty->dbh()->prepare("INSERT INTO {$opt["table_prefix"]}items(userid,name,description,price,source,category,url,ranking,comment,quantity,image_filename) " .
			    "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
			$stmt->bindParam(1, $userid, PDO::PARAM_INT);
			$stmt->bindParam(2, $name, PDO::PARAM_STR);
			$stmt->bindParam(3, $description, PDO::PARAM_STR);
			$stmt->bindParam(4, $price);
			$stmt->bindParam(5, $source, PDO::PARAM_STR);
			$stmt->bindParam(6, $category, PDO::PARAM_INT);
			$stmt->bindParam(7, $url, PDO::PARAM_STR);
			$stmt->bindParam(8, $ranking, PDO::PARAM_INT);
			$stmt->bindParam(9, $comment, PDO::PARAM_STR);
			$stmt->bindParam(10, $quantity, PDO::PARAM_INT);
            if (!isset($image_base_filename) || $image_base_filename == "") {
                $image_base_filename = NULL;
            }
			$stmt->bindParam(11, $image_base_filename, PDO::PARAM_STR);
			$stmt->execute();
			
			stampUser($userid, $smarty->dbh(), $smarty->opt());
			processSubscriptions($userid, $action, $name, $smarty->dbh(), $smarty->opt());

			header("Location: " . getFullPath("index.php"));
			exit;
		}
	}
	else if ($action == "update") {
		if (!$haserror) {
			// TODO: if the quantity is updated, send a message to everyone who has an allocation for it.
			$stmt = $smarty->dbh()->prepare("UPDATE {$opt["table_prefix"]}items SET " .
					"name = ?, " .
					"description = ?, " .
					"price = ?, " .
					"source = ?, " .
					"category = ?, " .
					"url = ?, " .
					"ranking = ?, " .
					"comment = ?, " . 
					"quantity = ? " .
					($image_base_filename != "" ? ", image_filename = ? " : "") .
					"WHERE itemid = ?");
			$stmt->bindParam(1, $name, PDO::PARAM_STR);
			$stmt->bindParam(2, $description, PDO::PARAM_STR);
			$stmt->bindParam(3, $price);
		    $stmt->bindParam(4, $source, PDO::PARAM_STR);
		    $stmt->bindParam(5, $category, PDO::PARAM_INT);
		    $stmt->bindParam(6, $url, PDO::PARAM_STR);
		    $stmt->bindParam(7, $ranking, PDO::PARAM_INT);
		    $stmt->bindParam(8, $comment, PDO::PARAM_STR);
		    $stmt->bindParam(9, $quantity, PDO::PARAM_INT);
		    if ($image_base_filename != "") {
				$stmt->bindParam(10, $image_base_filename, PDO::PARAM_STR);
				$stmt->bindValue(11, (int) $_REQUEST["itemid"], PDO::PARAM_INT);
			}
			else {
				$stmt->bindValue(10, (int) $_REQUEST["itemid"], PDO::PARAM_INT);
			}
			$stmt->execute();

			stampUser($userid, $smarty->dbh(), $smarty->opt());
			processSubscriptions($userid, $action, $name, $smarty->dbh(), $smarty->opt());

			header("Location: " . getFullPath("index.php"));
			exit;		
		}
	}
	else {
		echo "Unknown verb.";
		exit;
	}
}

$stmt = $smarty->dbh()->prepare("SELECT categoryid, category FROM {$opt["table_prefix"]}categories ORDER BY category");
$stmt->execute();
$categories = array();
while ($row = $stmt->fetch()) {
	$categories[] = $row;
}

$stmt = $smarty->dbh()->prepare("SELECT ranking, title FROM {$opt["table_prefix"]}ranks ORDER BY rankorder DESC");
$stmt->execute();
$ranks = array();
while ($row = $stmt->fetch()) {
	$ranks[] = $row;
}

$smarty->assign('userid', $userid);
$smarty->assign('action', $action);
$smarty->assign('haserror', isset($haserror) ? $haserror : false);
if (isset($_REQUEST['itemid'])) {
	$smarty->assign('itemid', (int) $_REQUEST['itemid']);
}
$smarty->assign('name', $name);
if (isset($descripton_error)) {
	$smarty->assign('name_error', $name_error);
}
$smarty->assign('description', $description);
if (isset($descripton_error)) {
	$smarty->assign('description_error', $description_error);
}
$smarty->assign('category', $category);
if (isset($category_error)) {
	$smarty->assign('category_error', $category_error);
}
$smarty->assign('price', $price);
if (isset($price_error)) {
	$smarty->assign('price_error', $price_error);
}
$smarty->assign('source', $source);
if (isset($source_error)) {
	$smarty->assign('source_error', $source_error);
}
$smarty->assign('ranking', $ranking);
if (isset($ranking_error)) {
	$smarty->assign('ranking_error', $ranking_error);
}
$smarty->assign('quantity', $quantity);
if (isset($quantity_error)) {
	$smarty->assign('quantity_error', $quantity_error);
}
$smarty->assign('url', $url);
if (isset($url_error)) {
	$smarty->assign('url_error', $url_error);
}
$smarty->assign('image_filename', $image_filename);
$smarty->assign('comment', $comment);
$smarty->assign('categories', $categories);
$smarty->assign('ranks', $ranks);
$smarty->display('item.tpl');
?>
