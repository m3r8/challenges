Das Datenbank-Projekt besteht aus vier einzelnen Projekten:

	ServerProject:
		Beinhaltet den Startup code für den Server.
		Die grundlegenden Klassen Program und Startup wurden aus dem dotnet mvc standart Projekt übernommen und angepasst.
		Hier werden alle Projekte zusammen geführt und dieses Projekt ist auch der Build-Endpunkt.
		Es müssen alle Projekte sowie die Packages die verwendet werden in der .csproj angegeben werden.

		Benötigte Packages:
			Microsoft.AspNetCore.App
			Microsoft.AspNetCore.Razor.Design (Version = 2.2.0 PrivateAssets="All")
			Microsoft.EntityFrameworkCore.Design (Version = 2.2.4)

		In Program cs wird der Server erstellt und ggf. die Datenbank geseedet.
		Dafür muss der DatenbankContext aus dem EfProject verwendet werden um die Datenbank zu Initialisieren und zu Migrieren.
		Wenn WebHost.CreateDefaultBuilder(args).UseStartup<Startup>() aufgerufen wird kann man mit .UseContentRoot(path) den
		Path zum Views-Ordner angeben mit .UseWebRoot(path) lässt sich der Path zu den statischen Datein angeben.
		Dies kann nützlich sein, wenn man noch im Entwicklungsprozess ist. Diese Angaben sollten aber beim Publish wieder entfernt bzw.
		Angepasst werden, da sie bei der gepublishten Anwendung auch angewand werden. Es ist besser die statischen Datein und den Views
		Ordner direkt beim Publish zu includieren, sodass kein Verweis mehr in Program.cs nötig ist. Per Default muss der Views Ordner Views heißen
		und der Ordner mit den statischen Datein wwwroot.
		
		Damit die Datenbank und die externen Controller benutzt werden können, müssen diese in Startup.cs intigriert werden.
		Die Controller lassen ich in der Methode ConfigureServices als Service hinzufügen:
		services.AddMvc().AddApplicationPart(typeof(ControllerClass).Assembly).AddControllersAsServices();
		Die Datenbank lässt sich über den DatenbankContext auch in der Methode ConfigureServices hinzufügen:
		services.AddDbContext<DatabaseContextClass>() (evt. muss hier der Konsturktor überschrieben werden)
		Schließlich muss noch service.AddMvc().SetCompatibiityVersion(CompatibilityVersion.Version_2_2) aufgerufen werden.
		
		In der Methode Configure lassen sich noch mehr Anpassungen machen z.B. das template der 
		routes verändern, damit ein Controller per Default verwendet wird.

		Damit alle Projekt im Server Projekt vereinigt werden können müssen diese auch in der .csproj
		referenziert werden.
		Es muss Außerdem <PreserveCompilationContext>true</PreserveCompilationContext> in der .csproj gesetzt sein,
		Damit die Views, die später angezeigt werden, compiled werden.
	
	EfProject:
		Beinhaltet die Models, die Datenbank und das seeding. Ist also das M in MVC Modell
		Um mit der Datenbank zu arbeiten, wird das Entity Framework verwendet, dies muss als Package installiert werden.

		Benötigte Packages:
			Microsoft.EntityFrameworkCore.Design (Version = 2.2.4)
			Microsoft.EntityFrameworkCore.SQLite (Version = 2.2.4)

		Die DatenbankKontextKlasse erbt von der DBContext Klasse und Verwendet die Model Klasse.
		Hier kann auch der Konstruktor überschrieben werden, um die Datenbank festzulegen und zu erstellen.
		Mit den Commands "dotnet ef migrations add InitialCreate" und "dotnet ef database update" wird das
		Datenbank-Schema in die Datenbank geschrieben und die Datenbank erzeugt. Es wird nach der Prinzip
		"Code first" gearbeitet, es muss aber nicht. In der Model Klasse wird im Grunde das Layout der 
		Tabelle für dieses Model in der Datenbank beschrieben. Dabei ist der Primärschlüssel ein Attribut mit dem
		Namen Id oder ModelNameId, man kann aber auch mit Annotationen einen Primärschlüssel erzwingen.
	
	ControllerProject:
		Im ControllerProject befinden sich die externen Controller für die Website. Ist also das C im MVC Modell
		
		Benötigte Packages:
			Microsoft.AspNetCore.App

		Benötigte Projekte:
			EfProject

		Diese Controller werden dann in der Service Klasse des ServerProject intigriert.
		Die Controller erben von der Klasse Controller und können so gestaltet werden, wie man es möchte.
		https://www.tutorialsteacher.com/mvc/mvc-controller

	ViewProject:
		Im ViewProject befinden sich die statischen und dynamischen Komponenten der Website. Ist also das M im MVC Modell
		Im Ordner Views sollten sich die dynamischen views für die Website befinden. Dieser Ordner sollte auch so gennante werden,
		da dies der default Name ist nach dem gesucht wird. Im Ordner wwwroot, der auch so heißen sollte, befinden sich die statischen Elemente der Website.
		Auf diese kann direkt über die Url zugegriffen werden.

		Benötigte Projekte:
			EfProjekt, falls man den Model-Typen auf der Website benötigt.	
	
	Publish:
		Um das Projekt nun zu publishen, muss in den .csproj Datein der Projekt die RID angeben werden:
		<RuntimeIdentifier>RID(win-x64)</RuntimeIdentifier>
		Im ServerProjekt sollte dann auch die Frameworkversion und TargetLatestRuntimePatch angeben werden:
		<TargetLatestRuntimePatch>true</TargetLatestRuntimePatch>
		<RuntimeFrameworkVersion>Frameworkversion</RuntimeFrameworkVersion> 
		In der .csproj vom ViewProject muss noch angeben werden, dass die Ordner Views und wwwroot beim publishen übernommen werden.
		<ItemGroup>
    			<Content Include="Views\**">
      				<CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
    			</Content>
  		</ItemGroup>
  		<ItemGroup>
    			<Content Include="wwwroot\**">
      				<CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
    			</Content>
  		</ItemGroup>		
		Nun kann mit dem Command "dotnet publish -c Release -r <RID>(win-x64) --self-contained"
		gepublished werden. Die Views werden nur übernommen aber nicht Compiled, wenn man die Views schon vorcompilen möchte,
		kann man sie auch als seperate dll einbinden. https://stackoverflow.com/questions/5500078/can-razor-views-be-compiled

	Javascript-API:
		Falls man mit Javascript oder einer andere Sprachen versucht die Seite als API zu verwenden, sollten ggf. die AntiRequestForgery Einstellungen für die gewollten
		Anfragen im Controller deaktiviert werden. Dies geht mit der Annotation [IgnoreAntiforgeryToken(Order = 1001)] über der jeweiligen Methode. Es muss außerdem evt.
		CORS im ServerProjekt aktiviert werden, damit die API Cross Origin im Browser aufrufbar ist.
		

	Globalisierung:
		Da es zu Problemen bei Dezimalzahlen kam, wurden noch globalisierungs plugins für jQuerry den statischen Elementen hinzugefügt
			
		
					
		
