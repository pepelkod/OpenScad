
module make_one(filename, height, even=true){
    difference(){  
        linear_extrude(height = height, center = true, scale=1)
            import(file =filename, center = true);
    }
}


make_one("FTPStemShell.svg", 24.5);

