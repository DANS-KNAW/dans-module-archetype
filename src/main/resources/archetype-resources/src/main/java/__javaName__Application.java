#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )

package ${package};

import io.dropwizard.core.Application;
import io.dropwizard.core.setup.Bootstrap;
import io.dropwizard.core.setup.Environment;
import ${package}.config.${javaName}Config;

public class ${javaName}Application extends Application<${javaName}Config> {

    public static void main(final String[] args) throws Exception {
        new ${javaName}Application().run(args);
    }

    @Override
    public String getName() {
        return "${projectName}";
    }

    @Override
    public void initialize(final Bootstrap<${javaName}Config> bootstrap) {
        // TODO: application initialization
    }

    @Override
    public void run(final ${javaName}Config config, final Environment environment) {

    }

}
