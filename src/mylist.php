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
	header("Location: " . getFullPath("login.php") . "?from=mylist.php");
	exit;
}
else {
	$userid = $_SESSION["userid"];
}

if (!empty($_GET["sortdir"])) {
	$sortdir = strtoupper(trim($_GET["sortdir"])) == "DESC" ? "DESC" : "ASC";
} else {
	$sortdir = "ASC";
}
if (empty($_GET["sort"])) {
	$sortby = "name";
	$sort = "name";
} else {
	$sort = filter_var(trim($_GET["sort"], FILTER_SANITIZE_STRING));;
	$sort = htmlspecialchars($sort, ENT_QUOTES, 'UTF-8');
	switch($sort) {
		case "category":
			$sortby = "category $sortdir, source, price";
			$sort = "category";
			break;
		case "name":
			$sortby = "name $sortdir, price";
			$sort = "name";
			break;
		case "source":
			$sortby = "source $sortdir, category, rankorder";
			$sort = "source";
			break;
		case "price":
			$sortby = "quantity * price $sortdir, category, source";
			$sort = "price";
			break;
		default:
			$sortby = "rankorder $sortdir, source, price";
			$sort = "ranking";
	}
}

try {
	// not worried about SQL injection since $sortby is calculated above.
	$stmt = $smarty->dbh()->prepare("SELECT name, description, source, price, r.title as ranktitle, i.comment, i.quantity, i.quantity * i.price AS total, rendered, c.category " .
			"FROM {$opt["table_prefix"]}items i " .
			"INNER JOIN {$opt["table_prefix"]}users u ON u.userid = i.userid " .
			"INNER JOIN {$opt["table_prefix"]}ranks r ON r.ranking = i.ranking " .
			"LEFT OUTER JOIN {$opt["table_prefix"]}categories c ON c.categoryid = i.category " .
			"WHERE u.userid = ? " .
			"ORDER BY " . $sortby);
	$stmt->bindParam(1, $userid, PDO::PARAM_INT);

	$stmt->execute();
	$shoplist = array();
	$totalprice = 0;
	$itemcount = 0;
	while ($row = $stmt->fetch()) {
		$totalprice += $row["total"];
		++$itemcount;
		if ($row["quantity"] == 1)
			$row["price"] = formatPrice($row["price"], $opt);
		else
			$row["price"] = $row["quantity"] . " @ " . formatPrice($row["price"], $opt) . " = " . formatPrice($row["total"], $opt);
		$shoplist[] = $row;
	}

	$smarty->assign('sort', $sort);
	$smarty->assign('sortdir', $sortdir);
	$smarty->assign('shoplist', $shoplist);
	$smarty->assign('totalprice', formatPrice($totalprice, $opt));
	$smarty->assign('itemcount', $itemcount);
	$smarty->assign('userid', $userid);
	$smarty->display('mylist.tpl');
}
catch (PDOException $e) {
	die("sql exception: " . $e->getMessage());
}
?>
