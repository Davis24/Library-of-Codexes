<?php
    require_once '../config/config.php';

    if(isset($_POST['data'])){
        $dir = "./downloads";
        
        $random_id = rand(1,5000000);	
        $zipname = $random_id.'_loc_ebooks.zip';
        $full_dir = $dir."/".$zipname;

        if (!file_exists($dir) && !is_dir($dir)) { //File exists and is a directory
            mkdir($dir,0744);         
        }

        if (is_writable(dirname($dir))) { //directory is writable 
            $ebooks = json_decode($_POST['data']);
            
            $zip = new ZipArchive;
            if($zip->open($full_dir, ZipArchive::CREATE|ZipArchive::OVERWRITE) === TRUE){
                
                foreach($ebooks as $e){
                    if(file_exists($e)){
                        $zip->addFile($e);    
                    }
                    else{
                        echo "Error occurred, please try again.";
                    }
                }

                if($zip->close()){
                    echo $full_dir;
                    //unlink($zipname);
                }
                else{
                    echo "Error occurred, please try again.";
                }
            }
            else{
                echo "Error occurred, please try again.";
            }
        }
        else{
            echo "Error occurred, please try again.";
        }           
    }
?>