<?php require_once 'inc/header.php'; ?>
<div class ="w3-display-container" style="padding:10px; padding-bottom:50px;">
    <div class="centering-text">
        <?php
            $titles = array("+1 to Intellect","Achievement Unlocked: Lore Expert","It's dangerous to go alone take this!", "+100 Reputation with College of Winterhold", "The book is a lie!","Books. Books never change.","Stay awhile, and read!", 
            "Books are super effective!", "Does this book have a soul?");
            $rand = rand(0, count($titles) -1);
        ?>
        <h1 style="padding-top:30px;"><b><?php echo $titles[$rand];?></b></h1>
        <h3>Read codexes from your favourite games.</h3>
        <br/><br/>
        <img src="<?php echo URLROOT;?>/img/books.png">
        <br/><br/>
        <br/><br/>
        <!-- Ebook Selection -->
        <form class="w3-container">
            <div class="w3-row" style="text-align:left;">
                <label><b>Select Videogame Series:</b></label>
                    <div class="checkbox-container centering">        
                    <?php 
                        $query = "SELECT TITLE FROM ebooks ORDER BY TITLE ASC";
                        if($result = $db -> query($query)){
                            while($row = $result -> fetch_assoc()) {
                                $val = str_replace(array(':','\''), '', $row["TITLE"]);
                                echo '<label class="checkbox-label"><input type="checkbox" class="w3-check" value="'.$val.'">'.$row["TITLE"]."</label>";
                            }
                        }                         
                    ?>                   
                    </div>
                <br>
                <label><b>Select Ebook Format:</b></label>
                <div class="select">
                    <select id="slct" name="ebook">
                        <option value="azw3">AZW3</option>
                        <option value="epub">EPUB</option>
                        <option value="pdf">PDF</option>
                    </select>
                </div>
            </div>
            <br> 
            <a id="download" href="#" class="w3-button w3-xlarge w3-block w3-green">Download</a>
        </form>
        <p id="ebook_info"></p>
        <br>

        <!-- End ebook selection -->
    </div><!-- center-text -->
</div><!-- w3-display-container -->
<?php require_once 'inc/footer.php'; ?>