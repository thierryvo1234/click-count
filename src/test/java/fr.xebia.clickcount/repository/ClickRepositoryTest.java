package fr.xebia.clickcount.repository;

import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioSocketChannel;
import org.junit.Assert;
import org.junit.Test;
import org.redisson.Config;
import org.redisson.Redisson;
import org.redisson.client.RedisClient;

import javax.xml.ws.Response;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.Scanner;




public class ClickRepositoryTest {
    //static final String WEB_APPS_URL = "http://localhost:8080/clickCount/";
    //static final String WEB_APPS_URL = "http:://8.8.8.8";
    static final String REDISHOST = "localhost";
    static final int REDISPORT = 6379;

    static final String WEB_APPS_URL = "http://localhost:8080";
    static final String REDIS_CONNECTION_URL = "http://"+REDISHOST+":"+REDISPORT;


    @Test
    public void TestExampleUnitTest() {
        Assert.assertEquals("Hello World, Unit Test", new String("Hello World, Unit Test"));
    }


    //If the web app can connect to the Redis DB, it won't throws an exception
    @Test
    public void IntegrationTestAccessWithRedisDB() throws IOException  {
        URL myURL = new URL(REDIS_CONNECTION_URL);
        URLConnection myURLConnection = myURL.openConnection();
        myURLConnection.connect();
    }


    private Redisson RedissonTestIncrementValueInRedisDB() throws IOException {

        int redisConnectionTimeout = 2000;

        Config config = new Config();
        config.useSingleServer().setAddress(String.format("%s:%d", REDISHOST, REDISPORT));

        Redisson redisson = Redisson.create(config);
        RedisClient redisClient = new RedisClient(new NioEventLoopGroup(), NioSocketChannel.class, REDISHOST, REDISPORT, redisConnectionTimeout);

        return redisson;
    }



    @Test
    public void IntegrationTestIncrementValueInRedisDB() throws IOException  {

        Redisson redisson = RedissonTestIncrementValueInRedisDB();
        redisson.getAtomicLong("test_increment_counter").delete();

        for(int i = 0 ; i< 5 ; i++) {
            redisson.getAtomicLong("test_increment_counter").incrementAndGet();
        }

        Assert.assertEquals(redisson.getAtomicLong("test_increment_counter").get(), 5) ;

        redisson.shutdown();
    }


    @Test
    public void IntegrationTestIncrementValueInRedisDB_NotEquals() throws IOException  {

        Redisson redisson = RedissonTestIncrementValueInRedisDB();
        redisson.getAtomicLong("test_increment_counter_not_equals").delete();

        for(int i = 0 ; i< 10 ; i++) {
            redisson.getAtomicLong("test_increment_counter_not_equals").incrementAndGet();
        }

        Assert.assertNotEquals(redisson.getAtomicLong("test_increment_counter_not_equals").get(), 5); ;

        redisson.shutdown();
    }



    /*@Test
    public void testCanViewFrontPageWebApp() throws IOException  {

        URL myURL = new URL("http://localhost:8080/c");
        // also you can put a port
        //  URL myURL = new URL("http://localhost:8080");
        URLConnection myURLConnection = myURL.openConnection();
        myURLConnection.connect();


    }*/

    //@Test
    //public void testCanViewFrontPageWebApp() throws IOException  {

     //   URL url = new URL(WEB_APPS_URL);

    //    HttpURLConnection httpcon = (HttpURLConnection) url.openConnection();
    //    httpcon.addRequestProperty("User-Agent", "Mozilla/4.76");
    //    httpcon.setRequestProperty("user-agent",httpcon.getHeader("user-agent"));

    //    String contentType = httpcon.getContentType();
    //    int code = httpcon.getResponseCode();

    //    Assert.assertEquals(code,200);


    //}
    /*
    @Test
    public void testCanViewItemA() {

        Response response = httpGet("A");
        assertThat(response.getStatus()).isEqualTo(200);
        String body = response.readEntity(String.class);
        assertThat(body.contains("Item A"));
    }*/


    //@Test
    //public void TestWhenSendingGet_thenMessageIsReturned() throws IOException {
        //String url = WEB_APPS_URL;
        //URLConnection connection = new URL(url).openConnection();
        //    InputStream response = connection.getInputStream();
        //    Scanner scanner = new Scanner(response);
        //    String responseBody = scanner.nextLine();


        /*URL url = new URL(WEB_APPS_URL);

        HttpURLConnection httpcon = (HttpURLConnection) url.openConnection();
        httpcon.addRequestProperty("User-Agent", "Mozilla/4.76");

        String contentType = httpcon.getContentType();
        System.out.println("contentType:" + contentType);




        Assert.assertEquals(contentType, new String("text/html;charset=utf-8"));
*/


        //Assert.assertEquals("Welcome to Thierry",new String(responseBody));

    //}
}