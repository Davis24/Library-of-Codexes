<div class="ui inverted vertical footer segment" >
        <div class="ui inverted center aligned container" style="padding-top:10px;">
            <h3 class="ui inverted  header">Level up your lore skill!</h3>
            <p>Powered by coffee, made with love. </p>
            <p style="margin-bottom:0px;">Library of Codexes @ 2019 </p>
          <div class="ui inverted horizontal  small divided link list">
              <a class="item" href="https://www.patreon.com/thelibrarian" target="_blank">Patreon</a>
              <a class="item" href="https://ko-fi.com/V7V7BH05" target="_blank">Ko-fi</a>
              <a class="item" href="privacy.php">Privacy Policy</a>
              <a class="item" href="https://www.carsonmcnamara.com/">Illustrations by Carson Mcnamara</a>
          </div>
        </div>
    </div>
    <footer>
        <script src="./scripts/jquery-3.4.1.min.js"></script>
        <script src="./scripts/home.js"></script>
        <!-- Production uses URLROOT /css/ -->
        <script src="<?php echo ROOT . 'resources/semantic/components/hamburger.js' ?>"></script> <!-- TODO: Get Hamburger added to semantic.js -->
        <script src="<?php echo ROOT . 'resources/semantic/semantic.min.js' ?>"></script><!-- TODO: Fix Exclusive for Accordian so I can switch back to min.js -->
        <script>
            $('.ui.dropdown').dropdown();
            $('.ui.accordion').accordion();
            $('.message .close')
            .on('click', function() {
                $(this)
                .closest('.message')
                .transition('fade')
                ;
            })
            ;
        </script>
    </footer>

</body>
</html>