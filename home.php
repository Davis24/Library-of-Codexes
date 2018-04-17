<?php require_once 'inc/header.php'; ?>

<div class ="w3-display-container" style="background-color:#FFF4D3 !important; padding:10px; padding-bottom:50px;">
    <div class="centering-text" style="text-align:center;">
        <?php
            $titles = array("+1 to Intellect","Achievement Unlocked: Lore Expert","It's dangerous to go alone take this!", "+100 Reputation with College of Winterhold", "The book is a lie!");
            $rand = rand(0, count($titles) -1);
        ?>
        <h1 style="padding-top:30px;"><b><?php echo $titles[$rand];?></b></h1>
        <h3>Read codexes from your favourite games.</h3>
        <br><br>
        <img src="<?php echo URLROOT;?>/img/books.png">
        <br><br>
        <br><br>
        <form>
            <div class="w3-row">
                <div class="w3-container w3-half">
                    <div class="select">
                        <select id="slct" name="game">
                        <option value="" disabled selected>Select Game</option>
                        <?php 
                            $query = "SELECT TITLE FROM ebooks ORDER BY TITLE ASC";
							if($result = $db -> query($query)){
  								while($row = $result -> fetch_assoc()) {
                                    $val = str_replace(array(':','\''), '', $row["TITLE"]);
    								echo '<option value="'.$val.'">'.$row["TITLE"]."</option>";
			  					}
                              }
                             
  						?>
                        </select>
                    </div>
                </div>
                <div class="w3-container w3-half">
                    <div class="select">
                        <select id="slct" name="ebook">
                            <option value="azw3">AZW3</option>
                            <option value="epub">EPUB</option>
                            <option value="pdf">PDF</option>
                        </select>
                    </div>
                </div>
            </div>
            <br>
            
        </form>
        <p id="ebook_info"></p>
        <br>
        <a id="download" href="#" class="w3-button w3-xlarge w3-round-large w3-blue" download>Download</a>
    </div>  
</div>

</div>
</body>
<?php require_once 'inc/footer.php'; ?>