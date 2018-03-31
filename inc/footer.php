<footer class="footer-basic-centered">
    <p class="footer-company-motto">Level up your lore skill.</p>
    <p class="footer-links">
        <a href="<?php echo URLROOT; ?>/home">Home</a> &#183;
        <a href="<?php echo URLROOT; ?>/about">About</a> &#183;
        <a href="https://www.patreon.com/thelibrarian" >Patreon</a> &#183;
        <a href="" >Paypal</a>
        </p>
    <p class="footer-company-name">Codexes utilized within this site are property of their publisher. Library of Codexes &copy; 2016</p>
</footer>
<script src = "<?php echo URLROOT; ?>/scripts/jquery-3.3.1.min.js"></script>
<script src="<?php echo URLROOT; ?>/scripts/change_text.js"></script>
<script src="<?php echo URLROOT; ?>/scripts/home.js"></script>
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