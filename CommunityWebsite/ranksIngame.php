<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<html><head>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
<style>
.table, th, td {
border: 0px solid black;
background-color: #428BCA;
border-color: #000 !important;
color: #FFF;
border-radius: 20px;
}
body{
background-color: #000;
}
.table{
width: 400px;
}
</style>
</head>
<body>
<center>
<?php
$start = round(microtime(true) * 1000);
$servername = "127.0.0.1";
$username = "root";
$password = "";
$dbname = "steam";


// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT * 
from steamname stn
JOIN steam st on st.steamId = stn.steamId 
JOIN steamcommunity sc on sc.steamId = stn.steamId
join rounds r on r.steamId = stn.steamId
join kills k on k.steamId = stn.steamId
WHERE stn.name not like 'Puppet%' 
order by cast(st.rank as signed) desc 
limit 20";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // output data of each row
$count = 1;
    echo "<table class='table table-bordered'>";
    echo "<center><h4><span class='label label-danger'>Top 20</span></h4></center><br /><thead><tr><th colspan='2'><center><span class='label label-success'>Position</span></center></th><th colspan='2'><center><span class='label label-success'>Name</span></center></th><th colspan='2'><center><span class='label label-success'>Rank</span></center></th></tr></thead>";
    while($row = $result->fetch_assoc()) {
    echo "<tr><td colspan='2'><center>". $count . "</center></td><td colspan='2'><center>". htmlspecialchars($row["name"]) . "</center></td><td colspan='2'><center>" . $row["rank"] . "</center></td></tr>";
     echo "<tr><th>Kills</th><th>Deaths</th><th>Headshot %</th><th>KDR</th><th>Win Rate</th><th>Community Profile</th></tr>";
     echo "<tr>";
     echo '<td>' . $row['kills'] . '</td>';
     echo '<td>' . $row['deaths'] . '</td>';
     echo '<td>' . round((($row['hskills']/$row['kills'])*100),2) . '%' . '</td>';
     echo '<td>' . round(($row['kills']/$row['deaths']),2) . '</td>';
     echo '<td>' . round($row['wins'] / $row['rounds'], 2) . '</td>';
     echo "<td colspan='1'>";
     if(isset($row['SteamID64'])) echo '<a style="color: red;" href=https://steamcommunity.com/profiles/' . $row['SteamID64'] . '>Steam Profile</a>';
     echo '</td>';

     echo '</tr>';
    $count+=1; 
    }
} else {
    echo "0 results";
}
echo "</table>";
$conn->close();
usleep(rand(2000,5000));
$end = round(microtime(true) * 1000)-$start;
echo "Took " . $end . " milliseconds to build this page.";
?> 
