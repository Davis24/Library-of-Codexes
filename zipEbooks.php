<?php
    require_once 'app/config/config.php';
    if(isset($_POST['data'])){
        $dir = "downloads";
        $random_id = rand(1,5000000);	
        $zipname = $random_id.'_loc_ebooks.zip';
        if (!file_exists($dir) && !is_dir($dir)) {
            mkdir($dir,0744);         
        }

        if (is_writable(dirname($dir.$zipname))) { 
            $ebooks = json_decode($_POST['data']);
            $zip = new ZipArchive;

            $zip->open($dir."/".$zipname, ZipArchive::CREATE|ZipArchive::OVERWRITE);
            foreach($ebooks as $val){
                $zip->addFile($val);
            }
            $zip->close();

            if(file_exists($dir."/".$zipname)){
                echo $dir."/".$zipname;
                unlink($zipname);
            }
            else{
                echo "File Does Not Exist";
            }  
        }
        else{
            echo "This downloads folder is not writable";
        }           
    }
?>