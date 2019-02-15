# Unit tests

Unit testing is just a specialized form of automated testing

My goal is to have unit tests that verify all the main functionality of an app. It doesn’t prevent all bugs, but it does verify that the core of my app will always work. I can push changes with confidence. No more worrying about angry calls and emails!

I like the quotation of Sandi Metz:
“Imagine being able to make any change you want in your code and know that you did not break something.”

We should write unit tests – which are critical to ensuring long-term quality and correctness.
 

## To provide Unit tests to our project, add these dependencies in the pom.xml:
```console
<dependencies>
...
    <dependency>
         <groupId>junit</groupId>
         <artifactId>junit</artifactId>
         <version>4.11</version>
         <scope>test</scope>
    </dependency>
</dependencies>
<build>
     <finalName>clickCount</finalName>
     <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.1</version>
            <configuration>
                <source>1.8</source>
                <target>1.8</target>
            </configuration>
        </plugin>
    </plugins>
</build>


```

 
Unit testing provides numerous benefits among :
 
### 1. Makes the Process Agile
When you add more and more features, you sometimes need to change old design and code. However, changing the already-tested  code is both risky and costly. If we have unit tests in place, then we can proceed for refactoring confidently.

In other words, unit tests facilitate safe refactoring. 

### 2. Quality of Code
Unit testing improves the quality of the code. Writing tests before actual coding makes you think harder about the problem. It exposes the edge cases and makes you write better code. 

### 3. Finds Software Bugs Early
Issues are found at an early stage. Since unit testing is carried out by developers who test individual code before integration, issues can be found very early and can be resolved then and there without impacting the other pieces of the code. 

### 4. Facilitates Changes and Simplifies Integration
Unit testing allows the programmer to refactor code or upgrade system libraries at a later date and make sure the module still works correctly.

Unit testing reduces defects in the newly developed features or reduces bugs when changing the existing functionality. 


### 5. Provides Documentation
Unit testing provides documentation of the system. Developers looking to learn what functionality is provided by a unit and how to use it can look at the unit tests to gain a basic understanding of the unit’s interface (API).

### 6. Debugging Process
Unit testing helps simplify the debugging process. If a test fails, then only the latest changes made in the code need to be debugged.

### 7. Design
Writing the test first forces you to think through your design and what it must accomplish before you write the code. This not only keeps you focused; it makes you create better designs. Testing a piece of code forces you to define what that code is responsible for. If you can do this easily, that means the code’s responsibility is well-defined and therefore that it has high cohesion.

### 8. Reduce Costs
Since the bugs are found early, unit testing helps reduce the cost of bug fixes. Just imagine the cost of a bug found during the later stages of development, like during system testing or during acceptance testing. 
 

# Integration tests

Even if unit testing is the practice of testing small pieces of code, typically individual functions, alone and isolated. If your test uses some external resource, like the network or a database, it’s not a unit test.
It would more likely be an Integration test.

As the name suggests, in integration testing the idea is to test how parts of the system work together – the integration of the parts. Integration tests are similar to unit tests, but there’s one big difference: while unit tests are isolated from other components, integration tests are not. As a result, when validating integration test results, you could, for example, validate a database related test by querying the database to check the database state is correct.



