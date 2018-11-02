<?php
    if(isset($_POST['data'])){
        $dir = 'C:/Users/Megan/Desktop/Loc_Test/';		
        $zipname = 'loc_ebooks.zip';
        if (!file_exists($dir) && !is_dir($dir)) {
            mkdir($dir,0744);         
            #echo "<p>The Folder should have been created.</p>";
        }

        if (is_writable(dirname($dir.$zipname))) {
            #echo "<p>The Downloads Folder is writable.</p>";
            
            $ebooks = json_decode($_POST['data']);
            $zip = new ZipArchive;

            $zip->open($dir.$zipname, ZipArchive::CREATE|ZipArchive::OVERWRITE);
            foreach($ebooks as $val){
                $zip->addFile($val);
            }
            $zip->close();

            if(file_exists($dir.$zipname)){
                echo "http://localhost/libraryofcodexes/downloads/loc_ebooks.zip";
                #unlink($zipname);
            }
            else
            {
                echo "File Does Not Exist";
            }
            
        }
        else
        {
            #echo "<p>This downloads folder is not writable</p>";
        }           
    }
    ?>