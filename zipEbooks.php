<?php
    if(isset($_POST['ebooks'])){
        $dir = 'downloads';
        
        $zipname = 'loc_ebooks.zip';
        if (!file_exists($dir) && !is_dir($dir)) {
            mkdir($dir,0744);         
        }
        else
        {
            if (is_writable(dirname(URLROOT.$zipname))) {
                echo "<p>".$zipname."</p>";
                
                $ebooks = json_decode(stripslashes($_POST['data']));
                $zip = new ZipArchive();

                $zip->open(URLROOT.$zipname, ZipArchive::CREATE|ZipArchive::OVERWRITE);
                foreach($ebooks as $val){
                    $zip->addFile($val);
                }
                
                $zip->close();
                header('Content-Type: application/zip');
                header('Content-disposition: attachment; filename='.$zipname);
                header('Content-Length: ' . filesize(URLROOT.$zipname));
                readfile(URLROOT.$zipname);
                #unlink($zipname);
            }
        } 
        
        
    }
?>