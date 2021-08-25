<html>
<head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="stylesheet" type="text/css" href="css/main.css">
</head>

<body>


        <div class="limiter">
                <div class="container-table100">
                        <?php
                                $filename = 'FILEPATH';
                                echo "<h1> Was last modified: " . date ("F d Y H
:i:s", filemtime($filename)) . "</h1>";
                        ?>
                        <input type="text" id="myInput" placeholder="Search for
names.." title="Type in a name">
                        <button onClick="myFunction()">Search</button>

                        <div class="wrap-table100">
						<?php
                                $filename = 'FILEPATH';
                                echo "<h1> Was last modified: " . date ("F d Y H:i:s", filemtime($filename)) . "</h1>";
                        ?>
                        <input type="text" id="myInput" placeholder="Search for names.." title="Type in a name">
                        <button onClick="myFunction()">Search</button>

                        <div class="wrap-table100">
                                <div class="table" id="tabla">
                                        <div class="row header">
                                                <div class="cell">
                                                        IP
                                                </div>
                                                <div class="cell">
                                                        Hostname
                                                </div>
                                                <div class="cell">
                                                        Izmjerena brzina
                                                </div>
                                                <div class="cell">
														Ugovorena brzina
                                                </div>
                                        </div>

<?php
        $fh = fopen($filename, 'r');

        while (($line = fgetcsv($fh)) !== false) {
                echo "<div class='row'>";
                echo "<div class='cell' data-title='IP'>" . htmlspecialchars($line[0]) . "</div>";
                echo "<div class='cell' data-title='Hostname'>" . htmlspecialchars($line[1]) . "</div>";
                echo "<div class='cell' data-title='Izmjerena brzina'>" . htmlspecialchars($line[2]) . "</div>";
                echo "<div class='cell' data-title='Ugovorena brzina'>" . htmlspecialchars($line[3]) . "</div>";
                echo "</div>\n";
        }
        fclose($fh);
?>
                                </div>
                        </div>
                </div>
        </div>

<script>
function myFunction() {
        var input, filter, table, tr, td, i, txtValue;
        input = document.getElementById("myInput");
        filter = input.value.toLowerCase();
        table = document.getElementById("tabla");
        tr = table.getElementsByClassName("row");

        for (i = 1; i < tr.length; i++) {
                var x = "none";

                for (var j = 0; j < 4; j++) {
                        td = tr[i].getElementsByTagName("div")[j];
                        if (td) {
								txtValue = td.textContent || td.innerText;
                                if (txtValue.toLowerCase().indexOf(filter) > -1) {
                                        x = "";
                                }
                        }
                }

                tr[i].style.display = x;
        }
}
</script>
</html>

