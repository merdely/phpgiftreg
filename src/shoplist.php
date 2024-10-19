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
	header("Location: " . getFullPath("login.php") . "?from=shoplist.php");
	exit;
}
else {
	$userid = $_SESSION["userid"];
}

$opt['show_helptext'] = $_SESSION['show_helptext'];

if (!empty($_GET["sortdir"])) {
	$sortdir = strtoupper(trim($_GET["sortdir"])) == "DESC" ? "DESC" : "ASC";
} else {
	$sortdir = "ASC";
}
if (empty($_GET["sort"])) {
	$sortby = "name $sortdir, price";
	$sort = "name";
} else {
	$sort = filter_var(trim($_GET["sort"], FILTER_SANITIZE_STRING));;
	$sort = htmlspecialchars($sort, ENT_QUOTES, 'UTF-8');
	switch($sort) {
		case "recipient":
			$sortby = "fullname $sortdir, source, price";
			$sort = "recipient";
			break;
		case "ranking":
			$sortby = "rankorder $sortdir, source, price";
			$sort = "ranking";
			break;
		case "source":
			$sortby = "source $sortdir, fullname, rankorder DESC";
			$sort = "source";
			break;
		case "price":
			$sortby = "a.quantity * i.price $sortdir, fullname, source";
			$sort = "price";
			break;
		default:
			$sortby = "name $sortdir, price";
			$sort = "name";
			break;
	}
}

try {
	// not worried about sql injection here since $sortby is a function of $sort, which falls through.
	$stmt = $smarty->dbh()->prepare("SELECT name, source, price, r.title as ranktitle, i.comment, a.quantity, a.quantity * i.price AS total, rendered, fullname " .
				"FROM {$opt["table_prefix"]}items i " .
				"INNER JOIN {$opt["table_prefix"]}users u ON u.userid = i.userid " .
				"INNER JOIN {$opt["table_prefix"]}ranks r ON r.ranking = i.ranking " .
				"INNER JOIN {$opt["table_prefix"]}allocs a ON a.userid = ? AND a.itemid = i.itemid AND bought = 0 " .
				"ORDER BY " . $sortby);
	$stmt->bindParam(1, $userid, PDO::PARAM_INT);

	$stmt->execute();
	$shoplist = array();
	$totalprice = 0;
	$itemcount = 0;
	while ($row = $stmt->fetch()) {
		$totalprice += $row["total"];
		++$itemcount;
		if ($row["quantity"] == 1) {
			$row["price"] = formatPrice($row["price"], $opt);
		}
		else {
			$row["price"] = $row["quantity"] . " @ " . formatPrice($row["price"], $opt) . " = " . formatPrice($row["total"], $opt);
		}
		$shoplist[] = $row;
	}

	$smarty->assign('sort', $sort);
	$smarty->assign('sortdir', $sortdir);
	$smarty->assign('shoplist', $shoplist);
	$smarty->assign('totalprice', formatPrice($totalprice, $opt));
	$smarty->assign('itemcount', $itemcount);
	$smarty->assign('userid', $userid);
	$smarty->display('shoplist.tpl');
}
catch (PDOException $e) {
	die("sql exception: " . $e->getMessage());
}
?>
