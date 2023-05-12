

public class HelloJava implements Execution {

	public ExecutionResult execute(MessageContext messageContext, ExecutionContext executionContext) {
		
		try {

		
           String name = messageContext.getMessage().getHeader("username");

if (name != null && name.length()>0) {
        messageContext.getMessage().setContent("Hello, " + name + "!");
        messageContext.getMessage().removeHeader("username");
} else {
        messageContext.getMessage().setContent("Hello, Guest!");
}    
            
            return ExecutionResult.SUCCESS;

		} catch (Exception e) {
			return ExecutionResult.ABORT;
		}
	}
}
