<footer class="footer-basic-centered">
    <p class="footer-company-motto">Level up your lore skill.</p>
    <p class="footer-links">
        <a href="<?php echo URLROOT; ?>/home">Home</a> &#183;
        <a href="<?php echo URLROOT; ?>/about">About</a> &#183;
        <a href="https://www.patreon.com/thelibrarian" target="_blank">Patreon</a> &#183;
        <a href="https://ko-fi.com/V7V7BH05" target="_blank">Buy Me a Coffee</a>
        </p>
    <p class="footer-company-name">Codexes utilized within this site are property of their publisher. Library of Codexes &copy; 2018</p>
</footer>
<script src = "<?php echo URLROOT; ?>/scripts/jquery-3.3.1.min.js"></script>
<script src="<?php echo URLROOT; ?>/scripts/change_text.js"></script>
<script src="<?php echo URLROOT; ?>/scripts/home.js"></script>
<script async src="https://c6.patreon.com/becomePatronButton.bundle.js"></script>
<!-- for mobile header -->
<script>
    function myFunction() {
        var x = document.getElementById("mobile");
        if (x.className.indexOf("w3-show") == -1) {
            x.className += " w3-show";
        } else { 
            x.className = x.className.replace(" w3-show", "");
        }
    }
</script>
</body>
</html>