import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.*;

public class GetWebpage {
	public static void main(String args[]) throws Exception {

    	// args[0] has the URL passed as the command parameter.
    	// You need to retrieve the webpage corresponding to the URL and print it out on console
    	// Here, we simply printout the URL
      
    	URL url = new URL(args[0]);
    	BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));

    	String content;
    	while ((content = in.readLine()) != null)
        	System.out.println(content);
    	in.close();
    }
}