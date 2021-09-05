#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )

package ${package};

import io.dropwizard.Application;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;

public class ${javaName}Application extends Application<${javaName}Configuration> {

    public static void main(final String[] args) throws Exception {
        new ${javaName}Application().run(args);
    }

    @Override
    public String getName() {
        return "${name}";
    }

    @Override
    public void initialize(final Bootstrap<${javaName}Configuration> bootstrap) {
        // TODO: application initialization
    }

    @Override
    public void run(final ${javaName}Configuration configuration, final Environment environment) {

    }

}
